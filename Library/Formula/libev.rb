require 'formula'

class Libev < Formula
  url 'http://dist.schmorp.de/libev/Attic/libev-4.04.tar.gz'
  homepage 'http://software.schmorp.de/pkg/libev.html'
  sha1 '7768c2bcce30dbf76672e51642a655479dd45772'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
