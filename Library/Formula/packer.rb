require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io'
  url 'https://dl.bintray.com/mitchellh/packer/0.1.4_darwin_amd64.zip'
  sha1 'c70deaf2b2532414171c8ceb5df6f845d45ad77a'

  def install
    bin.install 'packer'
    bin.install 'packer-builder-amazon-ebs'
    bin.install 'packer-builder-digitalocean'
    bin.install 'packer-builder-virtualbox'
    bin.install 'packer-builder-vmware'
    bin.install 'packer-command-build'
    bin.install 'packer-command-validate'
    bin.install 'packer-post-processor-vagrant'
    bin.install 'packer-provisioner-shell'
  end
end
