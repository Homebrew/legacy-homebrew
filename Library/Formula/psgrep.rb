require 'formula'

class Psgrep <Formula
  url 'http://psgrep.googlecode.com/files/psgrep-1.0.5.tar.bz2'
  head 'http://psgrep.googlecode.com/svn/trunk/'
  homepage 'http://code.google.com/p/psgrep/'
  md5 'aa09cd7826220fd0ea4c81d74575d065'

  def install
    bin.install "psgrep"
    man1.install "psgrep.1"
  end
end
