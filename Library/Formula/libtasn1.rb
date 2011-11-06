require 'formula'

class Libtasn1 < Formula
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-2.10.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 'ef80c227d0dcdc2940fbc58faf8e0cf1'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
