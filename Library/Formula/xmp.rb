require 'formula'

class Xmp < Formula
  url 'http://downloads.sourceforge.net/project/xmp/xmp/3.3.0/xmp-3.3.0.tar.gz'
  homepage 'http://xmp.sourceforge.net'
  md5 '0ac15cdb68cf0a08f418d37b4c1843bd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
