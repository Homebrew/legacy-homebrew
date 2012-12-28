require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-3.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-3.2.tar.gz'
  sha1 'a4bfcc575ca6e82e2b5bc1f39a8e0cc198b6ed19'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
