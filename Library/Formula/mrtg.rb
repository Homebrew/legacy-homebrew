require 'formula'

class Mrtg < Formula
  url 'http://oss.oetiker.ch/mrtg/pub/mrtg-2.17.2.tar.gz'
  homepage 'http://oss.oetiker.ch/mrtg/'
  md5 'f4c251ef883da2509188711eff4577ad'

  depends_on 'gd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
