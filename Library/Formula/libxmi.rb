require 'formula'

class Libxmi < Formula
  homepage 'http://www.gnu.org/software/libxmi/'
  url 'http://ftpmirror.gnu.org/libxmi/libxmi-1.2.tar.gz'
  mirror 'http://ftp.gnu.org/libxmi/libxmi-1.2.tar.gz'
  md5 '4e6935484f0ad71b531920bf4c546b47'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"
    system "make install"
  end
end
