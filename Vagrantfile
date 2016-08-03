# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
vagrantfile_api_version = "2"

# definitions for the machines provisioned by this vagrant file
box_params = {
  box: 'angelamancini/devbox',
  hostname: 'aws-api',
  playbook: 'ansible/playbook.yml'
}
# ports to forward
PORTS = [
  3000, # rails application
]
Vagrant.configure(vagrantfile_api_version) do |config|
  config.vm.define box_params.fetch(:hostname) do |box|
    # specify box, hostname
    box.vm.box = box_params.fetch :box
    box.vm.hostname = box_params.fetch :hostname
    # explicitly set hostname, because reasons
    box.vm.provision :shell, inline: "hostnamectl set-hostname #{box_params[:hostname]}" if box.vm.box == 'amancini/devbox'

    box.vm.provider "virtualbox" do |vb|
      vb.memory = "6000"
    end

    box.vm.provision "shell", inline: <<-SHELL
      sudo docker 2> /dev/null
      if [ $? -eq 0 ]
        then
          echo "Docker exists, skipping..."
          exit 0
        else
          sudo curl -sSL https://get.docker.com/ | sh
          sudo curl -L https://github.com/docker/compose/releases/download/1.4.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
          sudo chmod +x /usr/local/bin/docker-compose
      fi
      SHELL
      box.vm.provision :ansible do |ansible|
        ansible.playbook = box_params.fetch :playbook
      end
    end

  config.vm.synced_folder "./", "/app", type: 'nfs'

  # some networking
  config.vm.network :private_network, :auto_config => false, :ip => "192.168.33.10"

  # forward some ports, because pry is nice.
  PORTS.each do |port|
   config.vm.network :forwarded_port, guest: port, host: port
  end
end
