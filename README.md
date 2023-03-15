Deploy Microshift service
=========================

This role deploys Microshift service on RHEL 8/9.

Example deployment
------------------

* Install Ansible:

```sh
sudo dnf install -y ansible-core git
ansible-galaxy collection install community.general
ansible-galaxy collection install community.crypto
ansible-galaxy collection install ansible.posix
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
    use_copr_microshift: false
  roles:
    - ansible-microshift-role
EOF
```

* Deploy Microshift:

```sh
ansible-playbook -i inventory.yaml deploy-microshift.yaml
```
