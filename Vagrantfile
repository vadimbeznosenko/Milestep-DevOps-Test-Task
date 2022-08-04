VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
# Use the same key for each machine
  config.ssh.insert_key = false

  config.vm.define "linux1" do |vm1|
    vm1.vm.box = "bento/ubuntu-20.04"
    vm1.vm.network "public_network", ip: "192.168.31.10"
    vm1.vm.network "forwarded_port", guest: 22, host: 2209
    vm1.vm.network "forwarded_port", guest: 8080, host: 8080
    vm1.vm.hostname = "linux1"
    vm1.vm.provider "virtualbox" do |vb|
      vb.name = "linux1"
      vb.customize ["modifyvm", :id, "--memory", "2000"]
      vb.customize ["modifyvm", :id, "--cpus", "2"]

    vm1.vm.provision "ansible", playbook: "config.yml", inventory_path: "hosts.ini", limit: "all" 
end
end
end
