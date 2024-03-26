Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"

  # https://developer.hashicorp.com/vagrant/docs/synced-folders/smb
  config.vm.synced_folder ".", "/vagrant", type: "smb"  #, smb_username: "vshender"

  config.vm.provider "qemu" do |qe|
    qe.arch = "x86_64"
    qe.machine = "q35"
    qe.cpu = "max"
    qe.net_device = "virtio-net-pci"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt update
    sudo apt install -y gcc make gdb
  SHELL
end
