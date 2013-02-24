require 'formula'

class Mrtg < Formula
  homepage 'http://oss.oetiker.ch/mrtg/'
  url 'http://oss.oetiker.ch/mrtg/pub/mrtg-2.17.4.tar.gz'
  sha1 '5ae0e659001c613b847237a6b223b26cb7a8ab0f'

  depends_on 'gd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
