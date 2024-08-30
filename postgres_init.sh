#! /usr/bin/env bash

set -eu

start_postgres() {
    if postgres_is_stopped
    then
        logfile="$PWD/log/pg.log"
        mkdir -p "$PGHOST" "${logfile%/*}"
        (set -m
        pg_ctl start --silent -w --log "$logfile" -o "-k $PGHOST -h ''")
    fi
}

postgres_is_stopped() {
    pg_ctl status >/dev/null
    (( $? == 3 ))
}

case "$1" in
    add)
        if [ -d "$PGDATA" ]
        then
            start_postgres
        else
            pg_ctl initdb --silent -o '--auth=trust' && start_postgres && createdb $PGDATABASE
        fi
        ;;
    remove)
        if [ -n "$(find nix/pids -prune -empty)" ]
        then
            pg_ctl stop --silent -W
        fi
        ;;
    *)
        echo "Usage: ${BASH_SOURCE[0]##*/} {add | remove}"
        exit 1
        ;;
esac
