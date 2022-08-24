#!/bin/sh

# Pull kube-vip RBAC manifest, pull image, create alias
# (on k3s `ctr` is a link to `k3s` which has the namespace set by default but on rke2 we have to specify the namespace),
# generate manifest
curl -s https://kube-vip.io/manifests/rbac.yml > /var/lib/rancher/k3s/server/manifests/kube-vip-rbac.yml
crictl pull docker.io/plndr/kube-vip:$TAG
kubevip="ctr run --rm --net-host docker.io/plndr/kube-vip:$TAG vip /kube-vip"
$kubevip manifest daemonset \
--arp \
--interface $INTERFACE \
--address $VIP \
--controlplane \
--leaderElection \
--taint \
--services \
--inCluster | tee /var/lib/rancher/k3s/server/manifests/kube-vip.yml