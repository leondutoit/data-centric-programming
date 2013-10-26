# This file is used by vagrant to create the virtual environment

Vagrant::Config.run do |config|

    # Set up the box
    config.vm.box = "precise"

    # If box does not exist fetch it from this url
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Port forwarding
    #config.vm.forward_port 80, 8080

    #config.vm.share_folder "puppet_mount", "/puppet", "puppet"

    #config.vm.share_folder('puppet/modules', '/etc/puppet/modules', 'puppet/modules')
    #config.vm.share_folder('puppet/templates', '/tmp/vagrant-puppet/templates', 'puppet/templates')

    # Provisioning
    config.vm.provision :puppet,
    :options => ["--verbose", "--debug"] do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "setup.pp"
        puppet.module_path = "puppet/modules"
        #puppet.options = ["--templatedir", "/vagrant/puppet/templates"]

    end

end