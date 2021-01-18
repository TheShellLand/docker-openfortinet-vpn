#!/usr/bin/env bash

# user modifications

cd $(dirname $0)

set -ex

#source $ENVFILE

# this script will be ran by root
# use this for additional user changes

#git clone https://github.com/TheShellLand/antsable
#cd antsable
#./ansible.sh playbooks/devops.yml -c local -l local
#./ansible.sh playbooks/sudoer_nopass.yml -c local -l local
