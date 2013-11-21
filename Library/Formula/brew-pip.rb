require 'formula'

class BrewPip < Formula
  homepage 'https://github.com/edavis/brew-pip'
  url 'https://github.com/edavis/brew-pip/archive/v0.4.0.tar.gz'
  sha1 'd977a6d80709b3525f1b773e08ce3515315ea1d4'

  def install
    bin.install 'bin/brew-pip'
  end
end
