require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io/'
  if Hardware.is_32_bit?
    url "https://dl.bintray.com/mitchellh/packer/0.1.5_darwin_amd64.zip?direct"
    sha1 'bf79b92b5296625f4dec5edd4153f88af480901d'
  else
    url "https://dl.bintray.com/mitchellh/packer/0.1.5_darwin_amd64.zip?direct"
    sha1 '4696d29061e2483352f8a446c9228a726cc77950'
  end
  version '0.1.5'

  def install
    # Copy the prebuilt binaries to prefix
    bin.install Dir['*']
  end
end
