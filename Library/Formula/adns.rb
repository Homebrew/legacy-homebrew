require 'formula'

class Adns < Formula
  url 'http://ftpmirror.gnu.org/adns/adns-1.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/adns/adns-1.3.tar.gz'
  homepage 'http://www.chiark.greenend.org.uk/~ian/adns/'
  md5 'd19cddcc11ce3183549bab7f136e0f73'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-dynamic"
    system "make"
    system "make install"
  end
end
