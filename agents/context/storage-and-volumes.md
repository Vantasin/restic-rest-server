# Storage And Volumes Context

Persistent data is kept on a host path bind mount rather than in a named
volume.

## Current Model

- `REST_SERVER_DATA_ROOT` on the host is mounted to `/data` in the container
- `.htpasswd` lives under that path
- repositories live under `/data/repos` by default
- the default tracked path is `/tank/docker/data/restic-rest-server`
- the default repo clone location is `/tank/docker/compose/restic-rest-server`

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
