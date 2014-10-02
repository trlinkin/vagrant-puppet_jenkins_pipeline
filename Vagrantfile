# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/centos-6.5-64-puppet"

  config.vm.provision 'puppet' do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file  = 'site.pp'
    puppet.module_path    = 'puppet/modules'
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
