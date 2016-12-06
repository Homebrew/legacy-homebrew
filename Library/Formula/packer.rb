require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io/'
  url 'https://dl.bintray.com/mitchellh/packer/0.3.1_darwin_amd64.zip'
  sha256 '4b2cd0728799422c478853e87417c5efbf5e8b2d76c91b1cd910a2a2910c1585'

  def install
    %w(
      packer
      packer-builder-amazon-chroot
      packer-builder-amazon-ebs
      packer-builder-amazon-instance
      packer-builder-digitalocean
      packer-builder-virtualbox
      packer-builder-vmware
      packer-command-build
      packer-command-fix
      packer-command-validate
      packer-post-processor-vagrant
      packer-provisioner-file
      packer-provisioner-salt-masterless
      packer-provisioner-shell
    ).each do |binary_file|
      bin.install(binary_file)
    end
  end

end
