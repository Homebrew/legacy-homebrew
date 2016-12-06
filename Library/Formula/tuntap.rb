require 'formula'

class Tuntap <Formula
  url 'http://downloads.sourceforge.net/tuntaposx/tuntap_20090913_src.tar.gz'
  homepage 'http://tuntaposx.sourceforge.net/download.xhtml'
  md5 'f0eee87317066cd4ec7ed7f5c9fd1f7d'

  def install
    system "make all"
    system "make install"
  end
end
