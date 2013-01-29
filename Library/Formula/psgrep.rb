require 'formula'

class Psgrep < Formula
  homepage 'http://code.google.com/p/psgrep/'
  url 'http://psgrep.googlecode.com/files/psgrep-1.0.6.tar.bz2'
  sha1 'fe1102546971358a5eff2cff613d70ee63395444'

  head 'http://psgrep.googlecode.com/hg/', :using => :hg

  def install
    bin.install "psgrep"
    man1.install "psgrep.1"
  end
end
