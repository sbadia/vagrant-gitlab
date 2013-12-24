# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# For debian wheezy dev
# $ GUEST_OS=debian7 vagrant up
# or (debian7 is default os)
# $ vagrant up
#
# For centos 6 dev
# $ GUEST_OS=centos6 vagrant up

require 'yaml'

default_type = 'debian7'
type = ENV['GUEST_OS'] || default_type
boxes = YAML.load_file(File.join(File.dirname(__FILE__),'boxes.yml'))
box_data = boxes[type] || boxes[default_type]

Vagrant.configure('2') do |config|
  config.vm.define :gitlab do |hq|
    hq.vm.box     = box_data['name']
    hq.vm.box_url = box_data['url']
    hq.vm.hostname = "gitlab.localdomain.local"
    hq.vm.network :private_network, ip: "192.168.111.10"
    hq.vm.provider :virtualbox do |vb|
      vb.customize [ "modifyvm", :id,
	"--name", "gitlab_#{box_data['name']}",
	"--memory", "2048",
	"--cpus", "2"]
    end

    hq.vm.provision :puppet do |puppet|
      puppet.options = ["--certname gitlab_server"]
      logging = ENV['LOGGING']
      puppet.options << "--#{logging}" if ["verbose","debug"].include?(logging)
      puppet.module_path = "modules"
      puppet.manifests_path = "examples"
      puppet.manifest_file = "gitlab.pp"
    end
  end
end
