# dblinkhorn.k8s_homelab

This collection is the Ansible part of [k8s-homelab](https://github.com/dblinkhorn/k8s-homelab).
It connects to Ubuntu VMs over SSH, prepares them for Kubernetes, initializes
the control plane with kubeadm, and joins the workers. It also installs Cilium
for pod networking and Flux controllers.

The supported cluster has one amd64 control-plane node and at least one amd64
worker. Kubernetes uses kube-proxy for Service routing and CoreDNS for cluster
DNS.

For the full setup, start with the
[live-repository template](https://github.com/dblinkhorn/k8s-homelab-template).
It provisions the VMs with OpenTofu, generates Ansible inventory from your node
definitions, and runs this collection. The template's
README walks through the complete workflow.
