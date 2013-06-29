require 'formula'

class Packer < Formula
  homepage 'http://www.packer.io/'
  url 'http://dl.bintray.com/mitchellh/packer/0.1.1_darwin_386.zip?direct'
  sha1 '1535fd3b98d9de63624ad0fd2a476c9d67244c4c'
  version '0.1.1'

  def install
    bin.install Dir['*']
  end

end
