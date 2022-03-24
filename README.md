# What's here?

Bash scripts and Ansible playbooks to proof-of-concept local Alpine Linux Kubernetes nodes

# Why not k0s/K3s/microK8s/RKE2...?

- Local (no "free"-tier AWS/Azure/GCP/Oracle//IBM Cloud/requiring submitting payment details)
- Alpine Linux host nodes
- No Docker
- Cilium (see Caveats)
- Vagrant
- Ansible
- sh and awk

(Several stem from $work. Also: which parts of deploying K8s are enabled/smoothed by systemd?)

# How do I use it?

## Host requirements

- 4+ virtual CPU cores
- 16+ GiB RAM
- 25+ GiB disk
- systemd-based
- VirtualBox 6.1+
- Ansible (-base 2.10.7+, << 2.11; see Caveats) with ``community.general`` and ``ansible.posix`` galaxy collections
- Vagrant 2.2+ with [``vagrant-reload``](https://github.com/aidanns/vagrant-reload) and [``vagrant-sshfs``](https://github.com/dustymabe/vagrant-sshfs) plugins

(Of course, you also can modify the scripts and playbooks with replacements for systemd and VirtualBox, thereby rendering it viable on myriad platforms.)

Clone this repo, then create ``vagrant_loc`` in it with the fully qualified path to the vagrant executable, e.g.,

```
v=/usr/bin/vagrant
```

In ``Vagrantfile``, adjust the host-only ``private_network`` /24 CIDR as necessary. As of VirtualBox 6.1.30, also [add this CIDR to /etc/vbox/networks.conf](https://www.virtualbox.org/manual/ch06.html#network_hostonly).

If you change it, also note (or modify) ``apiserver`` in ``playbook2.yml``.

## Moar fast!

To provision the nodes: use either standard Terraform commands, or invoke ``to_parll.sh``.

## Caveats

Versioned URIs in the Ansible playbooks should be OK, but "latest" URLs will break since they're associated with SHA256sums.

If using Mitogen v0.3.0 on the host with Ansible (see [this note](https://mitogen.networkgenomics.com/ansible_detailed.html) and [these GitHub tags](https://github.com/mitogen-hq/mitogen/tags)), use the python2 Alpine apk (instead of python3) in the shell provision section of ``Vagrantfile``. On the host, PyPy* 7.3.8 do not work with Mitogen; you'll need to use CPython (tested with 3.10).

Cilium is configured to encipher inter-node traffic using WireGuard(tm), so expect several of the ``cilium connectivity test``s to fail.

## Known issues

Using host kernels newer than 5.16 will likely exhibit Cilium deployment failure due to changes in eBPF.

~~Deploying the Linkerd2 edge-21.9.3 [viz extension](https://linkerd.io/2/getting-started/) in a v1.22.2 cluster errors out; this is a [policy CRD v1beta1 interaction](https://github.com/linkerd/linkerd2/issues/6827).~~ (fixed in edge-21.9.4)

## License

Items in this repository are released into the public domain, AKA "The Unlicense," as per https://choosealicense.com/licenses/unlicense/

"[WireGuard](https://www.wireguard.com/)" is a registered trademark of Jason A. Donenfeld; and all others, of their respective holders.
