require 'formula'

class BrewPip < Formula
  homepage 'https://github.com/hanxue/brew-pip'
  url 'https://github.com/hanxue/brew-pip/archive/0.4.1.tar.gz'
  sha1 'be2bb7ade3394116f1be35771669e60321cdb2a7'

  def install
    bin.install 'bin/brew-pip'
  end
end
