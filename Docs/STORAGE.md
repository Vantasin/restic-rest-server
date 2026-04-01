# Storage

This repo intentionally uses a host path bind mount for persistent data instead
of a Docker named volume.

The default examples assume a ZFS-backed host with pool `tank`.

## Why A Host Path

- matches the clone, edit, deploy workflow used in the rest of your Docker
  repos
- keeps storage location explicit in `.env`
- makes filesystem, snapshot, and capacity planning a host concern instead of a
  hidden Docker volume concern
- leaves room for future migration to different storage backends or datasets

## Default Layout

`REST_SERVER_DATA_ROOT` is bind-mounted to `/data` in the container.

Recommended host layout:

```text
/tank/docker/
├── compose/
│   └── restic-rest-server/   # Git repo clone
└── data/
    └── restic-rest-server/
        ├── .htpasswd
        └── repos/
            ├── backup/
            │   ├── laptop/
            │   └── workstation/
            └── server/
                └── prod/
```

Equivalent service-data subtree:

```text
/tank/docker/data/restic-rest-server/
├── .htpasswd
└── repos/
    ├── backup/
    │   ├── laptop/
    │   └── workstation/
    └── server/
        └── prod/
```

With the default `--private-repos` option, the first path segment under
`repos/` maps to the authenticated username.

## Permissions

Recommended baseline:

```bash
sudo zfs create -p tank/docker/compose/restic-rest-server
sudo zfs create -p tank/docker/data/restic-rest-server
sudo chown "$USER":"$USER" /tank/docker/compose/restic-rest-server
sudo chmod 755 /tank/docker/compose/restic-rest-server
sudo chown root:root /tank/docker/data/restic-rest-server
sudo mkdir -p /tank/docker/data/restic-rest-server/repos
sudo chmod 700 /tank/docker/data/restic-rest-server
```

Recommended ownership split:

- Compose repo dataset: operator-owned, for example `$USER:$USER`
- Data dataset: `root:root`

Why:

- the Compose dataset is a Git working tree and local `.env` editing area
- the data dataset is bind-mounted live service state and should stay more
  restrictive by default

The bind-mounted path should live outside the Git repo. Do not store
repositories inside the clone.

## Quotas

Recommended baseline:

- set a ZFS quota on `tank/docker/data/restic-rest-server` so this service
  cannot consume the entire pool
- add per-user child datasets under `repos/` only if you want hard per-user
  storage boundaries

Example service-level quota:

```bash
sudo zfs set quota=2T tank/docker/data/restic-rest-server
```

### Optional Per-User Datasets

With the default `--private-repos` option, authenticated user `alice` can only
access `/alice` and below. That maps cleanly to a ZFS dataset mounted at:

```text
/tank/docker/data/restic-rest-server/repos/alice
```

Example:

```bash
sudo zfs create tank/docker/data/restic-rest-server/repos/alice
sudo zfs set quota=500G tank/docker/data/restic-rest-server/repos/alice
sudo chown root:root /tank/docker/data/restic-rest-server/repos/alice
sudo chmod 700 /tank/docker/data/restic-rest-server/repos/alice
docker compose exec rest-server create_user alice
```

Then the client can initialize repositories beneath that username prefix, for
example:

```bash
restic -r "rest:https://alice:<SERVER_PASSWORD>@backup.example.com/alice/laptop" init
```

Guidelines:

- create the dataset before the client writes to that path
- keep the dataset name and username aligned for the simple 1:1 model
- do not `mkdir` the same absolute per-user path first if it is meant to be a
  dataset mountpoint
- if you do not create a per-user dataset, restic will use a normal directory
  under `repos/`

### App-Level Limit Versus ZFS Quota

`rest-server` also supports `--max-size` in `REST_SERVER_OPTIONS`. Upstream
documents that flag as the maximum size of a repository in bytes.

Use it when you want an application-level repository limit. Use ZFS quotas when
you want a host-enforced filesystem boundary. They solve different problems.

## Capacity And Maintenance

- monitor free space on the filesystem that backs `REST_SERVER_DATA_ROOT`
- snapshot or back up the ZFS dataset or host storage layer separately if needed
- keep repository data and auth material on persistent storage before first
  production use

## Related Docs

- [`DEPLOYMENT.md`](./DEPLOYMENT.md)
- [`CONFIGURATION.md`](./CONFIGURATION.md)
- [`SECURITY.md`](./SECURITY.md)
