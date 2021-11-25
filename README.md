# Ansible playbook to install and setup a Wireguard VPN server

Ansible playbook with two roles:
  * installing Wireguard server (wireguard_install)
  * Create Wireguard configuration for client (wireguard_users)

### Requirements
* Minimal Version of the ansible for installation: 2.9
* Supported OS:
    * Ubuntu 20.04

### Variables
Variables can be found in current role directory (defaults/main.yml):
  * wireguard_install - /roles/wireguard_install/defaults/main.yml

| Variables      | Default |type |Descrription|
| :---        |    :----:   |:----: |  ---: |
package_list | wireguard,iptables, resolvconf| list|Packages fro installing wireguard |
|wg_conf_dir | /etc/wireguard | string | directory of wireguard configuration |
| public_ip | "{{ansible_default_ipv4.address}}" | string | public IP of wireguard server|
| public_nic | "{{ansible_default_ipv4.interface}}" | string| Public Network interface of wireguard server |
|wg_nic | wg0| string | Network interface for Wireguard |
|wg_ipv4 | 172.16.16.1| string | Wireguard IP |
|wg_port| 51094 | string | Wireguard Port|


  * wireguard_users - /roles/wireguard_users/defaults/main.yml

| Variables      | Default |type |Descrription|
| :---        |    :----:   |:----: |  ---: |
|| public_ip | "{{ansible_default_ipv4.address}}" | string | public IP of wireguard server|
|wg_nic | wg0| string | Network interface for Wireguard |
|wg_port| 51094 | string | Wireguard Port|
|allowed_ips| 0.0.0.0/0 | string| allowed IPs|
|wg_conf_dir | /etc/wireguard | string | directory of wireguard configuration |
|client_dns_1 | 8.8.8.8 | string | IP of DNS|
|client_dns_2 | 8.8.4.4 | string | Second IP of DNS |
|download_path | ./ansible_wirecard/config| string | path for saving client configs|
| wg_user_list |   user_1: username: myka wg_private_ip: 172.16.16.2    remove: false | dict | User parameters: username, ip for wireguard and status of user|


### Example Playbook
```
---
- name: install wireguard
  hosts: all
  become: true

  roles:
    - role: wireguard_install
      vars:
        package_list:
          - wireguard
          - iptables
          - resolvconf
        wg_conf_dir: /etc/wireguard
        public_ip: "{{ansible_default_ipv4.address}}"
        public_nic: "{{ansible_default_ipv4.interface}}"
        wg_nic: wg0
        wg_ipv4: 172.16.16.1
        wg_port: 51094

    - role: wireguard_users
      vars:
        public_ip: "{{ansible_default_ipv4.address}}"
        wg_nic:  wg0
        wg_port: 51094
        allowed_ips: 0.0.0.0/0
        wg_conf_dir: /etc/wireguard
        client_dns_1: 8.8.8.8
        client_dns_2: 8.8.4.4
        download_path: /Users/slevincalebra/Myproject/github/ansible_wirecard/config
        wg_user_list:
          user_1:
            username: myka
            wg_private_ip: 172.16.16.2
            remove: false

```


### Additional

https://www.wireguard.com

https://github.com/angristan/wireguard-install

https://www.procustodibus.com/blog/2021/03/wireguard-logs/
