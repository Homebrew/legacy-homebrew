require 'formula'

class Libxmi < Formula
  homepage 'http://www.gnu.org/software/libxmi/'
  url 'http://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz'
  mirror 'http://ftp.gnu.org/libxmi/libxmi-1.2.tar.gz'
  sha1 '62fa13ec4c8b706729c2553122e44f81715f3c0b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make install"
  end
end
