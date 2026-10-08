# dblinkhorn.k8s_homelab

Ansible collection for reproducing the current opinionated cluster baseline:
Ubuntu 24.04 nodes, containerd, kubeadm, Cilium with kube-proxy retained, and
Flux controllers installed without a reconciliation source.

The collection expects inventory groups named `k8s_control_plane`,
`k8s_workers`, and `k8s_nodes`. It supports exactly one control plane and one or
more workers.

For the complete Proxmox-to-Kubernetes setup, copy `examples/live-repo` from
the public repository. That starter defines nodes once and generates the
inventory from OpenTofu outputs. Its README describes the supported workflow.

A consuming repository can pin a release from this monorepo subdirectory:

```yaml
---
collections:
  - name: https://github.com/dblinkhorn/k8s-homelab.git#/ansible/collection/
    type: git
    version: <release-tag>
```

Install and run the complete bootstrap with:

```bash
ansible-galaxy collection install -r requirements.yml
ansible-playbook dblinkhorn.k8s_homelab.site -i inventory/homelab.ini
```

The collection includes roles for cloud-init validation, preflight, OS prep,
Kubernetes prerequisites, kubeadm control-plane bootstrap, worker join, Cilium,
and controller-only Flux installation. Public versions and behavior defaults
live in each role's `defaults/main.yml`; private inventories can override them
through normal Ansible precedence.
