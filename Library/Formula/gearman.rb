require 'formula'

class Gearman < Formula
  url 'http://launchpad.net/gearmand/trunk/0.18/+download/gearmand-0.18.tar.gz'
  homepage 'http://gearman.org/'
  md5 '07374f1d9990925e41527276f13a0628'

  depends_on 'libevent'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
