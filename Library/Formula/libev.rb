require 'formula'

class Libev <Formula
  url 'http://dist.schmorp.de/libev/libev-3.9.tar.gz'
  homepage 'http://software.schmorp.de/pkg/libev.html'
  md5 '40fe7d56d70db83cc0c22a6a68d87a96'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--mandir=#{man}"
    system "make install"
  end
end
