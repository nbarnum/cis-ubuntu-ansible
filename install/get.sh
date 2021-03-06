#!/bin/bash

set -o errexit

install_dependencies () {
  sudo apt-get update -qq

  local_co=""
  if [ -z "$IP" ]; then
    IP="127.0.0.1"
    local_co="-c local"
    sudo apt-get install -y aptitude
  fi

  sudo apt-get install -y git python-dev python-pip
  sudo pip install ansible markupsafe
}

install_playbook () {
  mkdir -p ansible/roles-ubuntu/roles
  cd ansible/roles-ubuntu
  if [ ! -e "roles/cis" ]; then
    git clone -b 18.04 https://github.com/nbarnum/cis-ubuntu-ansible.git roles/cis
  fi

  if [ ! -e "playbook.yml" ]; then
  cat >> playbook.yml << 'EOF'
---
- hosts: all
  roles:
    - cis
EOF
  fi

  hash_vars=`md5sum roles/cis/vars/main.yml | awk '{ print $1 }'`
  if [ "$hash_vars" == "09e0925d6b24d1a361a1a81338c5d3ec" ]; then
    cp roles/cis/tests/desktop_defaults.yml roles/cis/vars/main.yml
  fi
}

run_playbook () {
  ansible-playbook --tags "workstation_level_1" -b -u $USER $local_co -i "$IP," playbook.yml --ask-become-pass
}

install_dependencies
install_playbook
run_playbook
