require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-2.13.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.13.tar.gz'
  sha1 '89120584bfedd244dab92df99e955a174c481851'

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
