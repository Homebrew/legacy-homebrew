require 'formula'

class BrewPip < Formula
  url 'https://github.com/josh/brew-pip/tarball/v0.1.1'
  homepage 'https://github.com/josh/brew-pip'
  md5 '2c4b16e9129ab436a3db9cc3ce32b187'

  def install
    bin.install 'bin/brew-pip'
  end
end
