require 'formula'

class Gearman < Formula
  url 'http://launchpad.net/gearmand/trunk/0.24/+download/gearmand-0.24.tar.gz'
  homepage 'http://gearman.org/'
  md5 '7cd3bfedd37fd8f2d2c9a59333e08c8c'

  depends_on 'libevent'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
