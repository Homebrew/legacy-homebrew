require 'formula'

class Packer < Formula
  version '0.1.3'
  homepage 'http://www.packer.io/'
  url 'https://dl.bintray.com/mitchellh/packer/0.1.3_darwin_amd64.zip?direct'
  sha1 '2177c221cc439e8df3ddeada1feb1287727aa1a7'

  def install
    bin.install Dir['*']
  end
end
