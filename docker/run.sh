#!/bin/bash

##########################################################################################################

: ${VARNISH_CONFIG_FILE:=default.vcl}

##########################################################################################################

replace_vars() {
  OUTPUT=$(echo $1 | sed -e 's/.source//');
  SOURCE=$1

  eval "cat <<EOF
  $(<${SOURCE})
EOF
  " > ${OUTPUT}
}

replace_vars "/etc/varnish/${VARNISH_CONFIG_FILE}.source"

# run supervisor
/usr/bin/supervisord
