require 'formula'

class BrewPip < Formula
  homepage 'https://github.com/josh/brew-pip'
  url 'https://github.com/josh/brew-pip/tarball/v0.1.2'
  md5 'de88d7e2c08dc85d9f71ae5a2f3fdece'

  def install
    bin.install 'bin/brew-pip'
  end
end
