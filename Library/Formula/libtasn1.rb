require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-3.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-3.0.tar.gz'
  sha1 '0ce12f8b0460ae6eabf2a608506dbd337bf78a71'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
