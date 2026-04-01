# Storage And Volumes Context

Persistent data is kept on a host path bind mount rather than in a named
volume.

## Current Model

- `REST_SERVER_DATA_ROOT` on the host is mounted to `/data` in the container
- `.htpasswd` lives under that path
- repositories live under `/data/repos` by default
- the default tracked path is `/tank/docker/data/restic-rest-server`
- the default repo clone location is `/tank/docker/compose/restic-rest-server`
- the default ownership split is operator-owned Compose repo path and
  `root:root` service-data path
- optional per-user ZFS datasets can live under
  `/tank/docker/data/restic-rest-server/repos/<username>`
- app-layer `--max-size` limits and ZFS quotas are different controls and
  should not be treated as interchangeable

## Why This Matters

- keeps storage placement explicit in `.env`
- aligns with repo-root Docker deployment workflows used elsewhere
- aligns with the live server's ZFS-backed `tank/docker/{compose,data}` layout
- allows storage to move to separate filesystems or datasets later without
  changing the repo layout

## Non-Negotiables

- do not move repository data into the Git repo
- update `Docs/STORAGE.md` if paths or persistence semantics change
- update `Docs/DEPLOYMENT.md` if first-start directory creation changes
- keep quota guidance aligned between `Docs/STORAGE.md`,
  `Docs/CONFIGURATION.md`, and `env.example`
