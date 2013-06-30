require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io/'
  version '0.1.2'
  url 'https://github.com/mitchellh/packer/archive/v0.1.2.tar.gz'
  sha1 '8198f2a1e9971b2134092a31c0b4812d78dcf0af'
  head 'https://github.com/mitchellh/packer.git'

  depends_on 'go' => :build
  depends_on 'mercurial' => :build

  def install
    system 'make GOPATH=`pwd`'
    bin.install Dir['bin/*']
  end
end
