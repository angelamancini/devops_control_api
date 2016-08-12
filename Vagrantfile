# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
vagrantfile_api_version = "2"

# definitions for the machines provisioned by this vagrant file
box_params = {
  box: 'centos/7',
  hostname: 'doc',
  playbook: 'ansible/playbook.yml'
}

Vagrant.configure(vagrantfile_api_version) do |config|
  config.vm.define box_params.fetch(:hostname) do |box|
    # specify box, hostname
    box.vm.box = box_params.fetch :box
    box.vm.hostname = box_params.fetch :hostname

    # explicitly set hostname, because reasons
    box.vm.provision :shell, inline: "hostnamectl set-hostname #{box_params[:hostname]}"
    # allow guest os to use host os ssh keys
    box.ssh.forward_agent = true

    # some networking
    box.vm.network :private_network, :auto_config => false, :ip => "192.168.99.100"

    # mount the base dir in /home/vagrant/app instead of /vagrant
    config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder ".", "/home/vagrant/app"

    # bootstrap ansible
    box.vm.provision "shell", path: "ansible/install_ansible.sh"
    box.vm.provision :ansible do |ansible|
      ansible.playbook = box_params.fetch :playbook
    end # box.vm.provision
  end # config.vm.define
end # Vagrant.configure
