FROM eeacms/varnish
MAINTAINER jeff.tunessen@gmail.com

COPY docker/varnish/varnish.vcl /etc/varnish/conf.d/