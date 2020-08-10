#!/bin/bash

# proxy to vpn

cd $(dirname $0)

unset PIDS

while true; do
  set -xe

  killall kubectl || echo OK

  ssh dockerproxy -TN &
  PIDS=$!

  read -p ""

  kill "$PIDS"

  set +x
  sleep 1
done
