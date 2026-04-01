# Security

Restic encrypts backup data on the client before it reaches the REST server.
That reduces server-side trust requirements, but it does not remove transport
or access-control concerns.

## Base Security Model In This Repo

The default stack:

- keeps HTTP authentication enabled
- stores auth users in `.htpasswd`
- enables `--append-only`
- enables `--private-repos`
- joins the shared `npm_proxy` external Docker network
- does not configure built-in TLS inside the base Compose stack

This means the safe default deployment shape is:

- behind a same-host Nginx Proxy Manager reverse proxy that terminates HTTPS
  and forwards to `restic-rest-server:8000` on the shared Docker network

Direct unauthenticated exposure is out of scope for this repo.

## REST Server Vs SSH/SFTP

This repo is not the same security model as an SSH/SFTP-backed restic setup.

REST server model:

- HTTP Basic Auth or proxy-based auth controls access to the service
- `--private-repos` constrains users to their own repository path prefix
- `--append-only` helps limit damage from a compromised client
- transport security is an explicit HTTP/TLS or reverse-proxy decision

Credential split:

- rest-server username/password controls access to the HTTP service
- restic repository password encrypts the repository contents
- the client can manage the repository password without the server knowing it

SSH/SFTP model:

- access control is typically tied to SSH keys, shell restrictions, and
  filesystem permissions
- network exposure and authentication are handled by SSH rather than HTTP
- append-only behavior is not a built-in REST-server flag

## Secret Boundaries

Keep these separate:

- `.env`: operator-side deployment settings for the container
- `.htpasswd`: server-side HTTP auth database
- restic repository password: client-side repository secret

Do not treat `.htpasswd` or `.env` as interchangeable with the restic
repository password. They solve different problems.

## Reverse Proxy Guidance

For the default Nginx Proxy Manager deployment model:

- terminate HTTPS at Nginx Proxy Manager
- in Nginx Proxy Manager, forward to `restic-rest-server` on port `8000`
- forward only the intended hostname/path
- preserve access logs at the proxy and container layers as needed

Reference stack:
<https://github.com/Vantasin/Nginx-Proxy-Manager.git>

If you later choose built-in rest-server TLS instead, document the certificate
mounts and option changes in the human docs at the same time.

## Append-Only Vs Client-Managed Maintenance

Append-only mode:

- `REST_SERVER_OPTIONS="--path /data/repos --append-only --private-repos"`
- safer default for backup-only clients
- clients cannot use that endpoint for `forget` / `prune`

Client-managed maintenance mode:

- `REST_SERVER_OPTIONS="--path /data/repos --private-repos"`
- allows each authenticated client to run `forget` / `prune` against its own
  repository path
- increases the impact of a compromised client because that client can delete
  its own repository data

If you want per-user self-maintenance, client-managed maintenance mode is the
cleaner fit. If you want server-side append-only protection, keep the default.

## Related Docs

- [`DEPLOYMENT.md`](./DEPLOYMENT.md)
- [`CONFIGURATION.md`](./CONFIGURATION.md)
- [`OPERATIONS.md`](./OPERATIONS.md)
