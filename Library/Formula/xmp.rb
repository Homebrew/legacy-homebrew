require 'formula'

class Xmp < Formula
  url 'http://downloads.sourceforge.net/project/xmp/xmp/3.4.1/xmp-3.4.1.tar.gz'
  homepage 'http://xmp.sourceforge.net'
  md5 'cae0d0879b51f36a1056196522c899b1'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
