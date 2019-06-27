FROM ubuntu:19.04

RUN apt-get update \
    && apt-get -y install varnish supervisor \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && apt-get -y clean

ADD docker/prometheus_varnish_exporter-1.5.linux-amd64/prometheus_varnish_exporter /usr/local/bin/prometheus_varnish_exporter
ADD docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
ADD docker/varnish /etc/varnish/
ADD docker/run.sh /run.sh

RUN chmod +x /usr/local/bin/prometheus_varnish_exporter \
    && chmod +x /run.sh

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

EXPOSE 80

CMD ["/run.sh"]
