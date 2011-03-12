require 'formula'

class Libev <Formula
  url 'http://dist.schmorp.de/libev/Attic/libev-4.03.tar.gz'
  homepage 'http://software.schmorp.de/pkg/libev.html'
  md5 '86cd5c1b42fced1bd02c6e0119e9b865'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-shared"
    system "make install"
  end
end
