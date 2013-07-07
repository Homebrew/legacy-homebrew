require 'formula'

class Libev < Formula
  homepage 'http://software.schmorp.de/pkg/libev.html'
  url 'http://dist.schmorp.de/libev/Attic/libev-4.15.tar.gz'
  sha1 '88655b1e2c0b328c9f90a6df7e72361a97fa8dc3'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"

    # Remove compatibility header to prevent conflict with libevent
    (include/"event.h").unlink
  end
end
