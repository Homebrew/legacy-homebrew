require 'formula'

class Lightning < Formula
  url 'http://ftpmirror.gnu.org/lightning/lightning-1.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/lightning/lightning-1.2.tar.gz'
  md5 'dcd2c46ee4dd5d99edd9930022ad2153'
  homepage 'http://www.gnu.org/software/lightning/'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
    include.install "lightning.h"
  end
end
