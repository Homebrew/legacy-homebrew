require 'formula'

class Jigdo < Formula
  homepage 'http://atterer.org/jigdo/'
  url 'http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2'
  md5 'bbc1d9ac750bb34e0748f0b57157cc72'

  depends_on 'pkg-config' => :build
  depends_on 'berkeley-db'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end

  def test
    system "#{bin}/jigdo-file", "-h"
  end
end
