# Homelab live repository starter

Copy this directory into a new private repository. It contains the consumer
configuration for the public OpenTofu module and `dblinkhorn.k8s_homelab`
Ansible collection. You define the nodes once; inventory is generated from
OpenTofu state before Ansible runs.

The resulting baseline is Ubuntu 24.04, containerd, kubeadm, Cilium with
kube-proxy, CoreDNS, and Flux controllers. Flux has no reconciliation source
yet. This reproduces the existing bootstrap behavior; unpinned OS packages and
Kubernetes patch releases may change on subsequent fresh installations.

## Start your private repository

From a checkout of the public repository, copy the starter to a new directory:

```bash
cp -R examples/live-repo ../my-homelab-live
cd ../my-homelab-live
git init
cp infra/cluster.auto.tfvars.example infra/cluster.auto.tfvars
```

Use a private remote repository for this directory. The copied starter files
become yours; the module and collection are downloaded dependencies.

Install Git, Make, OpenTofu, Ansible Core, and an SSH client locally first.
The version requirements are declared in `infra/versions.tf` and the public
collection's `meta/runtime.yml`. You need access to the Proxmox API and the
VM network, an API token with provisioning permissions, and an SSH key pair.
The public key is installed in each VM; its private key must be available to
your SSH client (for example, through `ssh-agent`).

## Configure once

1. Replace `<release-tag>` in `infra/main.tf` and `ansible/requirements.yml`
   with the same published tag or commit containing both packages. The release
   must exist; `v0.1.0` is an example, not an automatically published release.
2. Edit `infra/cluster.auto.tfvars`: enter the Proxmox endpoint, node,
   datastores, DNS server, and each Kubernetes node's MAC and reserved IP.
3. Confirm template ID 9000 and node IDs 101, 111, and 112 are available in
   Proxmox; change them in your configuration if needed.
4. Configure your DHCP server with the listed MAC/IP reservations. The VMs use
   DHCP; `reserved_ip` records the expected address, not a static IP assignment.
5. Set `TF_VAR_proxmox_api_token` through your local secret manager or a secure
   shell environment. Do not put the token in committed files.

Defaults cover the `vmbr0` bridge, `~/.ssh/id_ed25519.pub`, the `ubuntu` user,
the Ubuntu template, and 2 CPUs / 4096 MiB RAM / 40 GiB disk for each node.
One control plane and two workers are shown. Add or remove worker entries as
needed; at least one worker is required.

Optional overrides go in the same configuration file. For example:

```hcl
network_bridge      = "vmbr1"
ssh_public_key_path = "~/.ssh/homelab.pub"
template_vm_id      = 9100
proxmox_insecure    = false # Use when the API certificate is trusted locally.
```

For a larger worker, add `cpu_cores = 4`, `memory_mb = 8192`, or
`disk_size_gb = 80` inside that worker's existing node entry. The default
`proxmox_insecure = true` retains support for self-signed Proxmox certificates.
Other available starter settings are documented in `infra/variables.tf`.

## Provision and bootstrap

Run these commands from the private repository root:

```bash
make doctor
make deps
make infra-init
make infra-plan
make infra-apply
make cluster-bootstrap
```

`make doctor` checks tool availability, configuration placeholders, matching
dependency references, and the credential environment variable. It does not
contact Proxmox or validate DHCP/SSH connectivity. OpenTofu validates its
version requirements and inputs during initialization and planning.

`make deps` installs the pinned collection in `ansible/.ansible/collections`.
The infrastructure targets run ordinary OpenTofu commands, and `infra-apply`
retains its interactive approval prompt. Review the plan before approving.

`make cluster-bootstrap` regenerates `ansible/inventory/homelab.yml` from the
applied OpenTofu output, checks playbook syntax, then runs the collection's
`site` playbook. Inventory generation errors stop the bootstrap. The generated
inventory is ignored; do not edit it. Use `make inventory` to regenerate it
without running Ansible. After changing node definitions, apply OpenTofu first
so the inventory reflects the updated state.

Bootstrap verifies node/network prerequisites, initializes Kubernetes, joins
workers, and validates Cilium, CoreDNS, kube-proxy, node readiness, and Flux.
Afterwards, run `make infra-plan` and `make cluster-bootstrap` again to check
infrastructure stability and Ansible idempotence.

If rebuilding nodes at previously used IP addresses, verify replacement SSH
host keys through a trusted channel and update the corresponding known-hosts
entries. Keep SSH host-key checking enabled.

## Files and ownership

Commit the non-secret cluster configuration, starter files, and
`infra/.terraform.lock.hcl` to your private repository. Keep credentials,
kubeconfigs, generated inventory, and tool caches out of Git. By default,
OpenTofu state is local under `infra/` and ignored; back it up securely or
configure a private remote backend before provisioning.

Normal users run `site.yml`. Advanced Ansible overrides can go in
`ansible/inventory/group_vars/k8s_nodes.yml`; public roles and templates stay
inside the installed collection. Some roles depend on earlier bootstrap
phases, so use the collection's orchestration playbooks for ordered execution.

To upgrade the public dependencies later, update both release references and
rerun dependency installation and the relevant commands. Copied starter files
do not automatically update. Cluster version upgrades remain explicit work;
changing a dependency reference does not itself upgrade a running cluster.
