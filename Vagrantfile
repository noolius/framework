# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Hosts
  N = 4
  (1..N).each do |machine_id|
    config.vm.define "node#{machine_id}" do |machine|
       machine.vm.hostname = "node#{machine_id}"
       machine.vm.network "private_network", ip: "192.168.133.#{machine_id}0"
       if "1" == "#{machine_id}"
         machine.vm.box = "alpine315-edge-control-plane"
       else
         machine.vm.box = "alpine315-edge-common"
       end
    end
  end

  # Template
  ##
  ## ---> Uses the following plugins: reload, sshfs
  ##
  config.vm.synced_folder ".", "/vagrant", type: "sshfs"
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    vb.cpus = "2"
  end

  # Provisioning
  config.vm.provision "ansible" do |ansible|
    ansible.groups = {
	"control_planes" => ["node1"],
	"workers" => ["node2", "node3", "node4"]
    }
    ansible.playbook = "playbook.yml"
  end
  config.vm.provision :reload
  config.vm.provision "ansible" do |ansible|
    ansible.groups = {
	"control_planes" => ["node1"],
	"workers" => ["node2", "node3", "node4"]
    }
    ansible.playbook = "playbook2.yml"
  end
end
