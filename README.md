# Ansible Microshift Role

## Overview and scope

The main goal of that project is to deploy the Microshift service by using
Ansible tool.

On top of the MicroShift [getting started](https://microshift.io/docs/getting-started/) instructions, this role performs the following actions deploy Microshift.

Optionally, the role allow to:
* Create a 'rhel' LVM Volume group on a flat file
* Deploy OLM
* Setup DNSMasq to ensure that Pods can resolv domain to the MicroShift deployment

## Role requirements

To run MicroShift, the minimum system requirements [are](https://github.com/openshift/microshift#system-requirements):

* x86_64 or aarch64 CPU architecture
* Red Hat Enterprise Linux 9 with Extended Update Support (9.2 or later)
* 2 CPU cores
* 2GB of RAM
* 2GB of free system root storage for MicroShift and its container images

Besides system requirements, it is necessary to provide a `pull-secret.txt`
content, which can be generated [here](https://console.redhat.com/openshift/create/local>).
and it is configured to your user account.
The pull-secret.txt content should be provided as a ansible variable: `openshift_pull_secret`.

## Role Variables

All of the parameters to setup the Ansible role are available in the [defaults](https://github.com/openstack-k8s-operators/ansible-microshift-role/blob/master/defaults/main.yaml) file.

## Usage

Example deployment:

* Install Ansible

```sh
sudo dnf install -y ansible-core git
ansible-galaxy collection install community.general community.crypto ansible.posix
```

* Clone Microshift Ansible role project

```sh
git clone https://github.com/openstack-k8s-operators/ansible-microshift-role
```

* Create ansible config:

```sh
cat << EOF > ansible.cfg
[defaults]
roles_path = ./
force_handlers = True

[ssh_connection]
pipelining = True
EOF
```

* Generate `pull-secret.txt` credentials

To deploy Microshift > 4.8, it requires to provide pull-secret.txt content.
It can be generated [here](https://cloud.redhat.com/openshift/create/local).

* Create inventory:

```sh
cat << EOF > inventory.yaml
all:
  vars:
    openshift_pull_secret: |
      < HERE IS pull.secret.txt content >
  hosts:
    microshift.dev:
      ansible_port: 22
      ansible_host: 127.0.0.1
      ansible_user: centos
EOF
```

* Create playbook:

```sh
cat << EOF > deploy-microshift.yaml
---
- hosts: microshift.dev
  vars:
    fqdn: microshift.dev
  roles:
    - ansible-microshift-role
EOF
```

* Deploy Microshift:

```sh
ansible-playbook -i inventory.yaml deploy-microshift.yaml
```

## Contributing

We welcome contributions to this project! Here's how you can get started:

* Fork this repository.
* Clone your forked repository to your local machine.
* Make changes to the code or documentation.
* Test your changes thoroughly.
* Commit your changes and push them to your forked repository.
* Create a pull request to the main branch of this repository.

The project maintainers would get a notification about your change and
you can expect, that soon your change would be reviewed!

If you don't want to create a pull request with a feature, you can allways
create an issue and describe the missing functionality. The project community
would reply you soon!

Thank you for considering contributing to this project!
