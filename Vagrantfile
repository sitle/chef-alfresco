# -*- mode: ruby -*-
# vi: set ft=ruby :

box_name = 'ubuntu-14.04-chef'
box_link = 'http://bit.ly/dsi-ubuntu-1404-box'

VAGRANTFILE_API_VERSION = 2

Vagrant.require_version '>= 1.5.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = 'alfresco'

  config.omnibus.chef_version = '11.16.4'
  config.berkshelf.enabled = true
  if Vagrant.has_plugin?('vagrant-cachier')
    config.cache.auto_detect = true
    config.cache.scope = :box
  end
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.ignore_private_ip = false
  config.hostmanager.include_offline = true
  config.hostmanager.aliases = %w(local.dev alfresco.dev)

  config.vm.box = box_name
  config.vm.box_url = box_link
  # config.vm.network :private_network, type: 'dhcp'
  # config.vm.network :public_network, ip: '10.4.0.20'
  config.vm.network :private_network, ip: '172.28.128.3'

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      alfresco: {
        domain_name: 'alfresco.dev',
        database_type: 'mysql'
      }
    }
    chef.run_list = [
      'recipe[alfresco::database]',
      'recipe[alfresco::alfresco]',
      'recipe[alfresco::share]',
      'recipe[alfresco::solr]',
      'recipe[alfresco::reverse]'
    ]
  end

  config.vm.provider :virtualbox do |p|
    p.customize ['modifyvm', :id, '--memory', '2048']
    p.customize ['modifyvm', :id, '--cpus', '2']
  end
end
