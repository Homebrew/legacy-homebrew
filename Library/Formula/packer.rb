require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io/'
  url 'https://github.com/mitchellh/packer/archive/v0.1.3.tar.gz'
  sha1 'e39f21fcba2cad07f0265ec2b63e4ecf6dfb3eb5'
  head 'https://github.com/mitchellh/packer.git'

  depends_on 'go' => :build
  depends_on 'mercurial' => :build

  def install
    system 'make GOPATH=`pwd`'
    prefix.install 'bin'
  end
end
