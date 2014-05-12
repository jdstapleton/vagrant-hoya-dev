# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
    # If you are using VirtualBox, you might want to enable NFS for shared folders
    # config.cache.enable_nfs  = true
  end
  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box                       = "precise64"
  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network "private_network", ip:"192.168.50.4"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 4096]
  end

  config.vm.provision :puppet do |puppet|
     puppet.manifests_path    = "puppet/manifests"
     puppet.module_path       = "puppet/modules"
     puppet.manifest_file     = "default.pp"
     puppet.options           = "--verbose --debug"
     #puppet.options = "--hiera_config /vagrant/puppet/hiera.yaml"
  end
end
