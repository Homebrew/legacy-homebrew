require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-2.14.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.14.tar.gz'
  sha1 '22f9e0b15f870c8e03ac9cc1ead969d4d84eb931'

  def install
    ENV.universal_binary
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
