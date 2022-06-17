# ansible-role-wireguard

Easy way to configure wireguard links

## Install

```shell
ansible-galaxy role install git+https://github.com/sergelogvinov/ansible-role-wireguard.git,main
```

## Usage

```ini
# inventory file

[peering]
peer1          ansible_host=1.2.3.1
peer2          ansible_host=1.2.3.2
peer3          ansible_host=1.2.3.3
```

```yaml
# hosts/peerX.yaml

# wg genkey | tee server.key | wg pubkey > server.pub
# cat server.*
wireguard_private_key: --key--
wireguard_public_key: --key--
```

```yaml
# values.yaml

- hosts: peering
  vars:
    wireguard_peers: "{{ groups['all'] | difference(inventory_hostname) | map('extract', hostvars) |
      community.general.json_query('[].{ ep: ansible_host, pub: wireguard_public_key, ips: wireguard_interface_address }') }}"
  roles:
    - ansible-role-wireguard
```
