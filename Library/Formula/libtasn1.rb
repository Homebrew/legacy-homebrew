require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-2.13.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.13.tar.gz'
  md5 'df27eaddcc46172377e6b907e33ddc83'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
