require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io/'
  version '0.1.1'
  url 'https://github.com/mitchellh/packer/archive/v0.1.1.tar.gz'
  sha1 '6f6b061498df5e43a982be766e59588b1fe0c915'
  head 'https://github.com/mitchellh/packer.git'

  depends_on 'go' => :build
  depends_on 'mercurial' => :build

  def install
    system 'make GOPATH=`pwd`'
    bin.install Dir['bin/*']
  end
end
