FROM ubuntu:19.04

RUN apt-get update \
    && apt-get -y install varnish supervisor \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean

ADD https://github.com/jonnenauha/prometheus_varnish_exporter/releases/download/1.5/prometheus_varnish_exporter-1.5.linux-amd64.tar.gz /
ADD docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD docker/varnish /etc/varnish/
ADD docker/run.sh /run.sh

RUN chmod +x /run.sh

#
# varnish defaults
#
ENV VARNISH_MEMORY 100M
ENV VARNISH_CONFIG_FILE default.vcl

#
# varnish vcl defaults
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

#ENV VCL_BACKEND_RESPONSE_BERESP_GRACE 6h
#ENV VCL_BACKEND_RESPONSE_BERESP_TTL 300s
#ENV VCL_BACKEND_RESPONSE_BERESP_TTL_ERROR 60s
#ENV VCL_BACKEND_RESPONSE_BERESP_TTL_ERROR_CODE 500
#ENV VCL_BACKEND_RESPONSE_BROWSER_CACHE_DISABLED true

CMD ["/run.sh"]
