# Ansible playbook to install and setup a Wireguard VPN server

Ansible playbook with roles for installing WireGuard VPN and for generating client configuration

## Repo includes

* main.yml - Ansible playbook
* ansible.cfg - ansible configuration
* roles:
  * wireguard_install - installing Wireguard server
  * wireguard_users -  create Wireguard configuration for client
* inventory - inventory of Ansible
* .vault_pass - file include password for ansible vault
* config - directory, where user configuration be saved
* keys.sh - script for generating private and public keys

## Requirements

* Minimal Version of the ansible for installation: 2.9
* wireguard-tools
* Ansible Vault
* Ubuntu 20.04
* bash
* qrencode (optional)

## Dependencies

Ansible playbook/roles depends on ansible vault, private and public keys for Wireguard.
Private and public keys can be generated by ```keys.sh``` script. The script works with arguments, where first argument is number of keys, second argument is path to vault password file. The default arguments is ```1``` and ```.vault_pass```.

The output of script will be encrypted private key (encrypted by ansible vault) and public key. The keys needs to be copied and pasted as variables to Ansible playbook.

You are able to check how script works in Example of use, bottom of the page.

## Variables

Variables can be found in current role directory (defaults/main.yml):

* ```wireguard_install``` - /roles/wireguard_install/defaults/main.yml

| Variables       |               Default                |       type       |                                 Descrription |
| :-------------- | :----------------------------------: | :--------------: | -------------------------------------------: |
| wg_package_list |    wireguard,iptables, resolvconf    |       list       |            Packages fro installing wireguard |
| wg_conf_dir     |            /etc/wireguard            |      string      |         directory of wireguard configuration |
| wg_public_ip    |  "{{ansible_default_ipv4.address}}"  |      string      |                public IP of wireguard server |
| wg_public_nic   | "{{ansible_default_ipv4.interface}}" |      string      | Public Network interface of wireguard server |
| wg_nic          |                 wg0                  |      string      |              Network interface for Wireguard |
| wg_ipv4         |             172.16.16.1              |      string      |                                 Wireguard IP |
| wg_port         |                51094                 |      string      |                               Wireguard Port |
| wg_private_key  |              !vault ...              | encrypted string |              Private key of wireguard server |
| wg_public_key   |            5x0XZG1RmHE...            |      string      |               Public key of wireguard server |

* ```wireguard_users``` - /roles/wireguard_users/defaults/main.yml

| Variables     |                                                         Default                                                          |  type  |                                                                      Descrription |
| :------------ | :----------------------------------------------------------------------------------------------------------------------: | :----: | --------------------------------------------------------------------------------: |
| wg_public_ip  |                                            "{{ansible_default_ipv4.address}}"                                            | string |                                                     public IP of wireguard server |
| wg_nic        |                                                           wg0                                                            | string |                                                   Network interface for Wireguard |
| wg_port       |                                                          51094                                                           | string |                                                                    Wireguard Port |
| allowed_ips   |                                                        0.0.0.0/0                                                         | string |                                                                       allowed IPs |
| wg_conf_dir   |                                                      /etc/wireguard                                                      | string |                                              directory of wireguard configuration |
| client_dns    |                                                     8.8.8.8, 1.1.1.1                                                     |  list  |                                                                        IPs of DNS |
| download_path |                                                ./ansible_wirecard/config                                                 | string |                                                    path for saving client configs |
| wg_public_key |                                                      5x0XZG1RmHE...                                                      | string |                                                    Public key of wireguard server |
| wg_user_list  | user_1: wg_user_private_ip: 172.16.16.2 wg_user_private_key: !vault ...  wg_user_public_key:/jfQZGhfLd...  remove: false |  dict  | User parameters: private ip, encrypted private key, public key and status of user |

## Example of use

### Generating keys

For generating keys (private and public) you need to use ```keys.sh``` script with arguments:

* first argument is number of keys
* path to vault password file

```sh
~$ ./keys.sh 1 .vault_pass

private_key = !vault |
      $ANSIBLE_VAULT;1.1;AES256
      33373566333137356563386337373661366531346561656539343132313436633633306133633362
      6432366263633037316534386639636161623764376338620a643937663539396137356430643236
      34336638646436656266333363373036373061626566373237633434323164376562636632383066
      6332306638373037320a313834653461333262663464373232383236633731643965333531623562
      65373536306362366438646162626130333864633038343532656262656138303764346265663261
      6433323637663965626663343035356563306238303466616535
public_key = I/jfQZGhfLdWIqRDTwS5Cpb3DzAmzGkqqUNUu/RLTlA=
------

```

### Ansible playbook

The private and public keys should be taken from output of ```./keys.sh``` script. And put the keys as variables to playbook.

```yaml
---
- name: install wireguard
  hosts: all
  become: true

  roles:
    - role: wireguard_install
      vars:
        wg_package_list:
          - wireguard
          - iptables
          - resolvconf
        wg_conf_dir: /etc/wireguard
        wg_public_ip: "{{ansible_default_ipv4.address}}"
        wg_public_nic: "{{ansible_default_ipv4.interface}}"
        wg_nic: wg0
        wg_ipv4: 172.16.16.1
        wg_port: 51094
        wg_private_key: !vault |....
        wg_public_key: a5x0XZG1RmHE....

    - role: wireguard_users
      vars:
        wg_public_ip: "{{ansible_default_ipv4.address}}"
        wg_nic:  wg0
        wg_port: 51094
        allowed_ips: 0.0.0.0/0
        wg_conf_dir: /etc/wireguard
        client_dns:
          - 8.8.8.8
          - 1.1.1.1
        download_path: ./config
        wg_user_list:
          user_1:
            wg_user_private_ip: 172.16.16.2
            wg_user_private_key: !vault |....
            wg_user_public_key: I/jfQZGhfLdW
            remove: false


~$ ansible-playbook main.yml --vault-password-file=.vault_pass
```

### Show client configs as QR code

After running playbook run the following script:

```sh
./qr-configs.sh
```

## Additional

https://www.wireguard.com

https://github.com/angristan/wireguard-install

https://www.procustodibus.com/blog/2021/03/wireguard-logs/
