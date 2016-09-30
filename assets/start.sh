#!/bin/bash
php5.6-fpm --fpm-config /etc/php/5.6/fpm/php-fpm.conf --nodaemonize &
pid1=$! 
nginx &
pid2=$!

function kill_child_processes {
    kill -$1 $pid1 $pid2
}

function trap_with_signal() {
    func="$1" ; shift
    for sig ; do
        trap "$func $sig" "$sig"
    done
}

trap_with_signal kill_child_processes SIGHUP SIGINT SIGTERM

wait $pid1 $pid2