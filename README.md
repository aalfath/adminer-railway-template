# Adminer on Railway

Railway template for [Adminer](https://www.adminer.org/), a database management tool in a single PHP file. It connects to MySQL, MariaDB, PostgreSQL, SQLite, MS SQL and Oracle out of the box.

## What it deploys

One service, **Adminer**, built from this repo's `Dockerfile`:

- Adminer **6.3.0**, the official Docker image pinned by digest: `adminer:6.3.0-standalone@sha256:7605e298e5a2ac74d806283362fa253a4e0a42cfd881e8fa2c155f0631899f6c`.
- A Railway volume at `/data` for PHP sessions, Adminer's `adminer.key` (it encrypts saved "permanent login" passwords) and the failed-login log, so logins and the brute-force lockout survive a redeploy.
- A Railway domain on port 8080, health check `/` and restart on failure, set in the Railway template (this repo has no `railway.json`).

No database is bundled. Deploy the template into the Railway project that holds your database (in the project: **Create → Template → Adminer**), or point it at any database it can reach.

What the wrapper adds to the official image:

- `railway-start.sh` prepares `/data` for the unprivileged `adminer` user, then drops root and starts the image's own entrypoint and PHP server on `PORT`.
- `railway.ini` and `railway-prepend.php`: sessions and temp files on `/data`, `Secure` cookies behind Railway's HTTPS edge, uploads up to 256 MB for SQL imports.
- Adminer's official `login-reverse-proxy` plugin is enabled. Behind Railway's proxy every request seems to come from the proxy, so without it 30 failed logins by anyone would lock everyone out for 30 minutes. With it, the lockout applies per client address.
- The login form's server field is prefilled with `postgres.railway.internal`, the private address of a Railway Postgres service named `Postgres`.

## Logging in

Adminer has no accounts of its own. Open the Railway URL, pick the database system, and sign in with the database's host, user and password. For a Railway database in the same project, use its private host (for example `postgres.railway.internal`, or `mysql.railway.internal` with port `3306`) and the credentials from its Variables tab. Adminer refuses logins with an empty password.

## Variables

| Variable | Default | Description |
|---|---|---|
| `PORT` | `8080` | Port Adminer listens on; the Railway domain points to it |

Optional, set on the service if you want them:

| Variable | Example | Description |
|---|---|---|
| `ADMINER_DEFAULT_SERVER` | `mysql.railway.internal` | Prefills the login form's server field |
| `ADMINER_DESIGN` | `dracula` | A bundled theme from the image's `designs/` folder |
| `ADMINER_PLUGINS` | `tables-filter dump-json` | Bundled plugins without required parameters, space separated |

## Updates

Projects deployed from the template build from this repo's `main` branch. When a new Adminer version is merged to `main`, Railway shows those projects an "update available" notice, and each owner chooses when to apply it. Every version is listed in [CHANGELOG.md](CHANGELOG.md), with breaking changes first.
