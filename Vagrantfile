# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  # Configuración del proveedor VirtualBox
  config.vm.provider :virtualbox do |vb|
    vb.gui = false
  end

  # Configuración del maestro
  config.vm.define :maestro do |maestro|
    maestro.vm.box = "bento/ubuntu-22.04"  # Especifica la caja para Ubuntu 22.04
    maestro.vm.network :private_network, ip: "192.168.50.3"
    maestro.vm.network "forwarded_port", guest: 80, host: 8080
    maestro.vm.hostname = "maestro"
    maestro.vm.synced_folder "./maestro", "/home/vagrant/maestro", type: "virtualbox"
  end

  # Configuración del esclavo
  config.vm.define :esclavo do |esclavo|
    esclavo.vm.box = "bento/ubuntu-22.04"  # Especifica la caja para Ubuntu 22.04
    esclavo.vm.network :private_network, ip: "192.168.50.2"
    esclavo.vm.hostname = "esclavo"
    esclavo.vm.synced_folder "./esclavo", "/home/vagrant/esclavo", type: "virtualbox"
  end
end
