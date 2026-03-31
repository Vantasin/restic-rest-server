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

Direct HTTP use on a trusted private network or VPN is still possible, but it
is no longer the primary documented path in this repo.

Direct unauthenticated exposure is out of scope for this repo.

## REST Server Vs SSH/SFTP

This repo is not the same security model as an SSH/SFTP-backed restic setup.

REST server model:

- HTTP Basic Auth or proxy-based auth controls access to the service
- `--private-repos` constrains users to their own repository path prefix
- `--append-only` helps limit damage from a compromised client
- transport security is an explicit HTTP/TLS or reverse-proxy decision

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

- keep `REST_SERVER_BIND_ADDRESS=127.0.0.1`
- keep `REST_SERVER_PROXY_NETWORK=npm_proxy`
- terminate HTTPS at Nginx Proxy Manager
- in Nginx Proxy Manager, forward to `restic-rest-server` on port `8000`
- forward only the intended hostname/path
- preserve access logs at the proxy and container layers as needed

Reference stack:
<https://github.com/Vantasin/Nginx-Proxy-Manager.git>

If you later choose built-in rest-server TLS instead, document the certificate
mounts and option changes in the human docs at the same time.

## Related Docs

- [`DEPLOYMENT.md`](./DEPLOYMENT.md)
- [`CONFIGURATION.md`](./CONFIGURATION.md)
- [`OPERATIONS.md`](./OPERATIONS.md)
