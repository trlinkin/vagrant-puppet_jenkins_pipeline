# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_version = '= 1.0.2'

  config.vm.hostname = 'jenkins.example.com'

  config.vm.provision 'puppet' do |puppet|
    puppet.environment = 'puppet'
    puppet.environment_path = '.'
  end

  script = <<-SCRIPT
    ip=`facter ipaddress`
    echo Your Jenkins instance is ready.
    echo
    echo The interface can be reached at the following URI:
    echo  *  http://$ip:8080
  SCRIPT

  config.vm.provision 'shell',
    inline: script

  config.vm.provider "vmware_fusion" do |v|
    v.vmx["memsize"] = "1024"
    v.vmx["numvcpus"] = "2"
  end
end
