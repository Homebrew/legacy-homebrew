require 'formula'

class Jigdo < Formula
  url 'http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2'
  homepage 'http://atterer.org/jigdo/'
  md5 'bbc1d9ac750bb34e0748f0b57157cc72'

  depends_on 'berkeley-db'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "jigdo-file -h"
  end
end
