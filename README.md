# ansible-role-wireguard

Easy way to configure wireguard peers

## Install

```shell
ansible-galaxy role install git+https://github.com/sergelogvinov/ansible-role-wireguard.git,main
```

## Usage

### Create wireguard keys

```shell
export ANSIBLE_VAULT_PASSWORD_FILE=pwd_file

make wireguard-key
```

### Deploy mesh network

```ini
# inventory file

[peering]
peer1          ansible_host=1.2.3.1
peer2          ansible_host=1.2.3.2
peer3          ansible_host=1.2.3.3
```

```yaml
# hosts/peerX.yaml

# from `make wireguard-key`
wireguard_private_key: --key--
wireguard_public_key: --key--
```

```yaml
# peers.yml

- hosts: peering
  vars:
    wireguard_peers: "{{ groups['all'] | difference(inventory_hostname) | map('extract', hostvars) |
      community.general.json_query('[?wireguard_public_key].{ ep: ansible_host, pub: wireguard_public_key, ips: wireguard_interface_address }') }}"
  roles:
    - ansible-role-wireguard
```

Finaly, apply the config:

```shell
ansible-playbook -Dv -i peers.ini peers.yml
```
