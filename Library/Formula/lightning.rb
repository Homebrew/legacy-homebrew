require 'formula'

class Lightning < Formula
  homepage 'http://www.gnu.org/software/lightning/'
  url 'http://ftpmirror.gnu.org/lightning/lightning-1.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/lightning/lightning-1.2.tar.gz'
  sha1 '09bee469782911bd81f545e4c2de667a6fbda0ee'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
    include.install "lightning.h"
  end
end
