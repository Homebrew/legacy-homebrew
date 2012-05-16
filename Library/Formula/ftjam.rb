require 'formula'

class Ftjam < Formula
  url 'http://sourceforge.net/projects/freetype/files/ftjam/2.5.2/ftjam-2.5.2.tar.bz2'
  homepage 'http://www.freetype.org/jam/'
  md5 'e61304b370ba06f68082f0219a196576'

  def install
    system "./configure", "--prefix=#{prefix}"
    system 'make'
    system 'make install'
  end
end
