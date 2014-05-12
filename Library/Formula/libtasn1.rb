require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-3.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-3.5.tar.gz'
  sha1 '7e38f027c765eb5434bf050aef0f20aee45e3420'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
