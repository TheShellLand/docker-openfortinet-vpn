#!/usr/bin/env bash

# create profile

cd $(dirname $0)

set -ex

python3 create_profile.py
