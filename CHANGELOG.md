# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.
Read the entry before you apply an update in Railway.

## 6.3.0-1 (2026-11-17)

- First version: Adminer [6.3.0](https://github.com/vrana/adminer/releases/tag/v6.3.0) (`adminer:6.3.0-standalone@sha256:7605e298e5a2ac74d806283362fa253a4e0a42cfd881e8fa2c155f0631899f6c`).
- Sessions, `adminer.key` and the failed-login log on a `/data` volume.
- `login-reverse-proxy` plugin enabled, so the failed-login lockout applies per client, not to everyone behind Railway's proxy.
- `Secure` cookies behind Railway's HTTPS edge; uploads up to 256 MB.
- Health check `/` and restart on failure are set in the Railway template, not in a `railway.json`.
- README: Deploy on Railway button (template `adminer-1`).
