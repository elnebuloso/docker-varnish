# docker-varnish

Varnish docker image with support for dynamic backends, Rancher DNS, auto-configure and reload.

- based on https://github.com/eea/eea.docker.varnish
- based on https://hub.docker.com/r/eeacms/varnish/

```
version: "2"
services:
  varnish:
    image: elnebuloso/varnish
    ports:
    - "80:6081"
    - "6085:6085"
    depends_on:
    - anon
    - auth
    - download
    environment:
      COOKIES: "true"
      COOKIES_WHITELIST: "(SESS[a-z0-9]+|SSESS[a-z0-9]+|NO_CACHE)"
      BACKENDS: "anon auth download"
      BACKENDS_PORT: "8080"
      DNS_ENABLED: "true"
      BACKENDS_PROBE_INTERVAL: "3s"
      BACKENDS_PROBE_TIMEOUT: "1s"
      BACKENDS_PROBE_WINDOW: "3"
      BACKENDS_PROBE_THRESHOLD: "2"
      DASHBOARD_USER: "admin"
      DASHBOARD_PASSWORD: "admin"
      DASHBOARD_SERVERS: "varnish"
      DASHBOARD_DNS_ENABLED: "true"
  anon:
    image: eeacms/hello
    environment:
      PORT: "8080"
  auth:
    image: eeacms/hello
    environment:
      PORT: "8080"
  download:
    image: eeacms/hello
    environment:
      PORT: "8080"
```