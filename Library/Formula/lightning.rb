require 'formula'

class Lightning < Formula
  homepage 'http://www.gnu.org/software/lightning/'
  url 'http://ftpmirror.gnu.org/lightning/lightning-2.0.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/lightning/lightning-2.0.1.tar.gz'
  sha1 'cd4f655b314301e9f12a4832de124888b0e9e6da'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end
end
