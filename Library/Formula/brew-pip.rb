require 'formula'

class BrewPip < Formula
  homepage 'https://github.com/josh/brew-pip'
  url 'https://github.com/josh/brew-pip/tarball/v0.1.2'
  sha1 '0fac3fe1b9563f6a7fb69d257b4146678fd540a4'

  def install
    bin.install 'bin/brew-pip'
  end
end
