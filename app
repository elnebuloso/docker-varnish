#/bin/bash

tty=
tty -s && tty=--tty
tag=docker-varnish

case "$1" in
    start)
        docker-compose pull
        docker-compose up --build --remove-orphans -d
    ;;

    stop)
        docker-compose down --remove-orphans
    ;;

    *)
        echo "- create"
        echo "- sh"
        echo "- run"
    ;;
esac