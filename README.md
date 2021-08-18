# What's here?

Bash scripts and Ansible playbooks to proof-of-concept local, three-node Alpine Linux with Cloud Foundry

# Why not k0s/K3s/microK8s/RKE2...?

Framework:

- Local (no "free"-tier AWS/Azure/GCP/Oracle//IBM Cloud/requiring submitting credit card details)
- Alpine Linux nodes
- No Docker
- Cilium (kube-proxy-free with transparent encryption)
- Vagrant
- Ansible
- sh and awk

Several stem from $work. Also: which parts of deploying K8s are enabled/smoothed by systemd?

# How do I use it?

For the host, minimum:

- 6 virtual CPU cores
- 8 GiB RAM
- 50 GiB disk

On the host, use a systemd-based Linux distribution with these additions:

- VirtualBox 6.1+ with Guest Additions (for shared folders and nested virtualization on AMD **or** Intel)
- Ansible 2.10.7+
- Vagrant 2.2+ with vagrant-reload plugin

(Of course, you also can modify the scripts and playbooks with replacements for systemd and VirtualBox, thereby rendering it viable on myriad platforms.)

Clone this repo, then create ``vagrant_loc`` in it with the fully qualified path to the vagrant executable, e.g.,

```
v=/usr/bin/vagrant
```

In ``Vagrantfile``, adjust the ``private_network`` /24 CIDR as necessary.

If you change it, also note (or modify) ``apiserver`` (twice) in ``playbook2.yml``.

Note also the comment in ``Vagrantfile`` regarding the vbguest plugin.

## Caveats

The URLs in the playbooks may break (and using URLs with unarchive is likely poor form).

## License

Items in this repository are released into the public domain, AKA "The Unlicense," as per https://choosealicense.com/licenses/unlicense/