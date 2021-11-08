# What's here?

Bash scripts and Ansible playbooks to proof-of-concept a local Alpine Linux cluster with Cloud Foundry

# Why not k0s/K3s/microK8s/RKE2...?

- Local (no "free"-tier AWS/Azure/GCP/Oracle//IBM Cloud/requiring submitting credit card details)
- Alpine Linux nodes
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

In ``Vagrantfile``, adjust the ``private_network`` /24 CIDR as necessary.

If you change it, also note (or modify) ``apiserver`` (twice) in ``playbook2.yml``.

See also [this section](https://docs.projectcalico.org/getting-started/kubernetes/installation/config-options#switching-from-ip-in-ip-to-vxlan) for applied modifications to ``calico.yaml``.


## Moar fast!

To provision the nodes as quickly as possible, e.g.,

```
./to_provision.sh  106.84s user 30.59s system 54% cpu 4:13.32 total
```

versus


```
.../vagrant up  90.74s user 29.74s system 19% cpu 10:32.48 total
```

(performed some while ago with three VBox nodes on a 64GiB Ryzen 7 4800H, USB "SuperSpeed Plus" 3.2 Gen 2x1 external SSD, 1Gb WAN)

## Caveats

Versioned URIs in the Ansible playbooks should be OK, but "latest" URLs will break since they're associated with SHA256sums.

If using Mitogen v0.3.0 with Ansible (see [this note](https://mitogen.networkgenomics.com/ansible_detailed.html) and [these GitHub tags](https://github.com/mitogen-hq/mitogen/tags)), use the python2 Alpine apk (instead of python3) in the shell provision section of ``Vagrantfile``.

Cilium is used in Calico-chaining mode and not as a kube-proxy replacement, so expect several of the ``cilium connectivity test``s to fail.

Calico is configured to encipher intra-cluster pod traffic using WireGuard(tm).

## Known issues

~~Deploying the Linkerd2 edge-21.9.3 [viz extension](https://linkerd.io/2/getting-started/) in a v1.22.2 cluster errors out; this is a [policy CRD v1beta1 interaction](https://github.com/linkerd/linkerd2/issues/6827).~~ (fixed in edge-21.9.4)

## License

Items in this repository are released into the public domain, AKA "The Unlicense," as per https://choosealicense.com/licenses/unlicense/
