<img src="https://raw.githubusercontent.com/elnebuloso/docker-varnish/master/logo.png" width="100%"/>

# docker-varnish

![Release](https://github.com/elnebuloso/docker-varnish/workflows/Release/badge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/elnebuloso/varnish.svg)](https://hub.docker.com/r/elnebuloso/varnish)
[![GitHub](https://img.shields.io/github/license/elnebuloso/docker-varnish.svg)](https://github.com/elnebuloso/docker-varnish)

Dockerized Varnish 6 with Prometheus Exporter

## github

- https://github.com/elnebuloso/docker-varnish

## docker

- https://hub.docker.com/r/elnebuloso/varnish
- https://hub.docker.com/r/elnebuloso/varnish/tags?page=1&ordering=last_updated

## configuration

- You can pass environmental variables to customize configuration
- By convention, you should prefix every variable used in vcl context with _ENV__

## varnish config

```
#
# varnish defaults
#
ENV VARNISH_MEMORY 100M
ENV VARNISH_CONFIG_FILE default.vcl

#
# varnish vcl overall settings
#
ENV VCL_SETTING_CACHE_LARGE_STATIC_FILES false
ENV VCL_SETTING_CACHE_STATIC_FILES false

#
# varnish vcl
#
ENV VLC_BACKEND_HOST backend
ENV VLC_BACKEND_PORT 80
ENV VLC_BACKEND_PROBE_REQUEST_HOSTNAME backend-origin
ENV VLC_BACKEND_PROBE_REQUEST_QUERY /
ENV VLC_BACKEND_PROBE_REQUEST_INTERVAL 5s
ENV VLC_BACKEND_PROBE_REQUEST_TIMEOUT 5s
ENV VLC_BACKEND_PROBE_REQUEST_WINDOW 5
ENV VLC_BACKEND_PROBE_REQUEST_THRESHOLD 3
ENV VLC_BACKEND_FIRST_BYTE_TIMEOUT 300s
ENV VLC_BACKEND_CONNECT_TIMEOUT 5s
ENV VLC_BACKEND_BETWEEN_BYTES_TIMEOUT 2s
ENV VCL_PIPE_BEREQ_HTTP_CONNECTION_CLOSE_ENABLED false
ENV VLC_HIT_KEEP_OBJECTS_IN_CACHE_BEYOND_TTL false
ENV VCL_BACKEND_RESPONSE_BERESP_TTL_DEFAULT 120s
ENV VCL_BACKEND_RESPONSE_BERESP_GRACE 6h
```

### configuration explained

Due to the way varnish works with it's config file, there is no easy way to pass environment variables to it. People have come up with a work-around: http://stackoverflow.com/questions/21056450/how-to-inject-environment-variables-in-varnish-configuration - and that is actually similar to what our image is doing. Basically, you'll have 2 files:

_Note: the path to vlc file is fix under /etc/varnish, see ENV VARNISH_CONFIG_FILE default.vcl_

```
/etc/varnish/default.vcl.source
/etc/varnish/default.vcl
```

The source file contains any environment variables you want parsed (that are available). 
The run command (part of the image) replaces the defined variables in the source file with the environment variable values using sed and outputs it to the .vcl file. Then it starts varnish and reads the .vcl file. So you can think of default.vcl.source as a template and the .vcl file as throwaway (as it get's overwritten every startup).

One thing to note is whatever you define in the yml file (VARNISH_CONFIG_FILE: default.vcl) needs a matching .source 

## development

```
# start stack
docker-compose up --build --remove-orphans -d

# stop stack
docker-compose down --remove-orphans
```

### test urls

- http://whoami.127.0.0.1.xip.io/
- http://whoami-origin.127.0.0.1.xip.io/