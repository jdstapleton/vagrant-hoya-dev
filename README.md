vagrant-hoya-dev
================

Vagrant vm for hoya development

Usage:

1. Install Vagrant
  * See http://www.vagrantup.com/
1. Checkout this repository
1. Install cachier
  * See http://fgrehm.viewdocs.io/vagrant-cachier
  * Just need to do: vagrant plugin install vagrant-cachier
1. run vagrant up
1. Hopefully if all goes well it will start up a vm ready for hoya development

Optional procedure:
1.  Since most of my vms I like my development workspace exposed, I add this line to my global vagrant  file
  - Edit ~/.vagrant.d/VagrantFile
  - Replace 'workspaces' to whereever you keep the root of your project's source tree.
  - ```
       Vagrant.configure("2") do |config|
         config.vm.synced_folder "~/.m2", "/home/vagrant/.m2"
         config.vm.synced_folder "~/workspaces", "/home/vagrant/workspaces"
       end
    ```
  - If you prefer not to edit the global Vagrant file, you can just add the synced_folder to the VagrantFile after you checkout this project
