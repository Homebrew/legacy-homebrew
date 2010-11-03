require 'formula'

class Libev <Formula
  url 'http://dist.schmorp.de/libev/libev-4.00.tar.gz'
  homepage 'http://software.schmorp.de/pkg/libev.html'
  md5 '7b8fb956152e55b3b12795dff18f99f8'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--mandir=#{man}"
    system "make install"
  end
end
