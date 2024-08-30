#! /usr/bin/env bash

set -eu

client_pid=$PPID

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

rm nix/pids/$client_pid
if [ -n "$(find nix/pids -prune -empty)" ]
then
    pg_ctl stop --silent -W
fi
