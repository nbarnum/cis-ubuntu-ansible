# CIS for Ubuntu 17.10

Based on https://github.com/awailly/cis-ubuntu-ansible
and Uber's mountopts https://github.com/Uberspace/ansible-mountopts

## Prerequisites

The role is focused on hardening an Ubuntu 17.10 system. The minimum requirements of the targeted system are `ssh`, `aptitude` and `python2`; `ansible>=1.9` is required on your local system.

## Usage

### One liner installation & execution

The following will automatically install Ansible, download and run the playbook on your local system.

```
$ \curl -sSL https://raw.githubusercontent.com/nbarnum/cis-ubuntu-ansible/17.10/install/get.sh > /tmp/cis.sh && bash /tmp/cis.sh
```

To apply the playbook on a remote system:

```
$ IP=[remote host's IP] USER=[remote user] \curl -sSL https://raw.githubusercontent.com/nbarnum/cis-ubuntu-ansible/17.10/install/get.sh | bash
```

### Manual installation

Install dependencies on your host:

```bash
$ sudo apt-get update
$ sudo apt-get install python-pip git python-dev
$ sudo pip install ansible markupsafe
```

Create a placeholder to describe your machine:

```bash
$ mkdir -p ansible/roles-ubuntu/roles
$ cd ansible/roles-ubuntu
$ git clone https://github.com/nbarnum/cis-ubuntu-ansible.git roles/cis
```

Create a playbook in the _roles-ubuntu_ folder:

```bash
$ cat >>  playbook.yml << 'EOF'
---
- hosts: all
  roles:
    - cis
EOF
```

### Tuning the environment

You have to tune the environment to match your security requirements. The default is very restrictive and will perform strong modifications on the system. All requirements are enabled and may not work. For example the rsyslog server address have to be defined to respect the CIS rule.

*Read `default/main.yml` file and set your variables in `vars/main.yml`*

For the CI tests we only create specific files for the environment (see `tests/travis_defaults.yml`) in the `vars/` directory.

### Running the role

Replace the target information (USER, IPADDRESS) and run the playbook with a version of ansible higher than 1.8:

    $ ansible-playbook -b -u USER -i 'IPADDRESS,' playbook.yml

Note that this command will perform modifications on the target. Add the `-C` option to only check for modifications and audit the system. However, some tasks cannot be audited as they need to register a variable on the target and thus modify the system.

If the user you are using is not privileged you have to use the `-b` (`become`) option to perform privilege escalation. The password required to become superuser can be specified with the `--ask-become-pass` option.

### Optimizations

Ansible come with some great options that can improve your operations:

- Add the `-e "pipelining=True"` option to the command line to speed up the hardening process.
- Specify the private key to use with the `--private-key=~/.ssh/id_rsa` option.
- The conventional method to specify hosts in ansible is to create an `inventory` file and feed it with a group of hosts to process.

## Documentation

The details of each tasks operated on the target system is available in the in the `docs/` directory.

## TODO

  - Add script for "5.4.1.5 Ensure all users last password change date is in the past (Scored)"

## License

This project is under [GPL license](LICENSE).
