# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
vagrantfile_api_version = "2"

# definitions for the machines provisioned by this vagrant file
box_params = {
  box: 'angelamancini/devbox',
  hostname: 'aws-api',
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

  end
  # key stuff
  # config.ssh.private_key_path = "~/.ssh/id_rsa"
  config.ssh.forward_agent = true
  # some networking
  config.vm.network :private_network, :auto_config => false, :ip => "10.0.2.2"

  # forward some ports, because pry is nice.
  PORTS.each do |port|
   config.vm.network :forwarded_port, guest: port, host: port
  end
end
