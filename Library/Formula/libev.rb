require 'formula'

class Libev <Formula
  url 'http://dist.schmorp.de/libev/libev-4.01.tar.gz'
  homepage 'http://software.schmorp.de/pkg/libev.html'
  md5 '2a6e0d3d7eda7d54b39f3800b8279707'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-shared"
    system "make install"
  end
end
