require 'formula'

class Psgrep < Formula
  url 'http://psgrep.googlecode.com/files/psgrep-1.0.6.tar.bz2'
  head 'http://psgrep.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/psgrep/'
  sha1 'fe1102546971358a5eff2cff613d70ee63395444'

  def install
    bin.install "psgrep"
    man1.install "psgrep.1"
  end
end
