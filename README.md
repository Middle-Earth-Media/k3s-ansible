This repository includes code to run kubectl and helm commands on the same machine you run ansible commands from.


ansible.cfg
  Configure this file to tell ansible where to look for its inventory file and roles


inventory/group_vars/k3s_cluster.yml
  Configure this file like this:
  ---
  k3s_version: v1.23.4+k3s1
  # this is the user that has ssh access to these machines
  ansible_connection: ssh
  ansible_user: ******
  ansible_password: ******
  ansible_python_interpreter: /usr/bin/python3
  systemd_dir: /etc/systemd/system

  # Set your timezone
  system_timezone: "America/Chicago"

  # interface which will be used for flannel
  flannel_iface: "eth0"

  # apiserver_endpoint is virtual ip-address which will be configured on each master
  apiserver_endpoint: "192.168.0.200"

  # k3s_token is required  masters can talk together securely
  # this token should be alpha numeric only
  k3s_token: "******"

  # change these to your liking, the only required one is--no-deploy servicelb
  # remove --no-deploy traefik because will be installing ourselves
  extra_server_args: "--no-deploy servicelb --no-deploy traefik --write-kubeconfig-mode 644"
  extra_agent_args: ""

  # image tag for kube-vip
  kube_vip_tag_version: "v0.4.4"

  # image tag for metal lb
  metal_lb_speaker_tag_version: "v0.12.1"
  metal_lb_controller_tag_version: "v0.12.1"

  # metallb ip range for load balancer
  metal_lb_ip_range: "192.168.0.210-192.168.0.254"


inventory/host_vars/ansible.yml
  Configure this file like this:
  ---
  # apiserver_endpoint is virtual ip-address which will be configured on each master
  apiserver_endpoint: "192.168.0.200"
  k3s_version: v1.23.4
  traefik_user: ******
  traefik_pass: ******
  # get traefik_secret with the following line:
  # traefik_secret = htpasswd -nb {{ traefik_user }} {{ traefik_pass }} | openssl base64
  traefik_secret: ******
  cloudflare_email: ******
  cloudflare_token: ******


config/config.k3s-server-1.yml
  Configure this file like this:
  ---
  write-kubeconfig-mode: "0644"
  tls-san:
  - (all dns entries for this node here on separate lines)
  - 192.168.0.200


config/config.k3s-server-2.yml
  Configure this file like this:
  ---
  write-kubeconfig-mode: "0644"
  tls-san:
  - (all dns entries for this node here on separate lines)
  - 192.168.0.200


config/config.k3s-server-3.yml
  Configure this file like this:
  ---
  write-kubeconfig-mode: "0644"
  tls-san:
  - (all dns entries for this node here on separate lines)
  - 192.168.0.200