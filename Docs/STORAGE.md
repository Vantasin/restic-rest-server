# Storage

This repo intentionally uses a host path bind mount for persistent data instead
of a Docker named volume.

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
/srv/restic-rest-server/
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
sudo mkdir -p /srv/restic-rest-server/repos
sudo chmod 700 /srv/restic-rest-server
```

The bind-mounted path should live outside the Git repo. Do not store
repositories inside the clone.

## Capacity And Maintenance

- monitor free space on the filesystem that backs `REST_SERVER_DATA_ROOT`
- snapshot or back up the host storage layer separately if needed
- keep repository data and auth material on persistent storage before first
  production use

## Related Docs

- [`DEPLOYMENT.md`](./DEPLOYMENT.md)
- [`CONFIGURATION.md`](./CONFIGURATION.md)
- [`SECURITY.md`](./SECURITY.md)
