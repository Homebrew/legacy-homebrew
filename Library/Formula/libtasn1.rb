require 'formula'

class Libtasn1 < Formula
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-2.11.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.11.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 'ee8076752f2afcbcd12f3dd9bc622748'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
