# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "base"

  # The url from where the 'config.vm.box' box will be fetched
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"

  # Enable and configure the chef solo provisioner
  config.vm.provision :chef_solo do |chef|
    # We're going to download our cookbooks from the web
    chef.recipe_url = "http://files.vagrantup.com/getting_started/cookbooks.tar.gz"

    # Tell chef what recipe to run. In this case, the `vagrant_main` recipe
    # does all the magic.
    chef.add_recipe("vagrant_main")
  end

  config.vm.forward_port 3000, 3000
end

