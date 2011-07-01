require 'formula'

class Gearman < Formula
  url 'http://launchpad.net/gearmand/trunk/0.22/+download/gearmand-0.22.tar.gz'
  homepage 'http://gearman.org/'
  md5 '197ef3b6fe96cefcd535261f78ef1908'

  depends_on 'libevent'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
