require 'formula'

class Gearman <Formula
  url 'http://launchpad.net/gearmand/trunk/0.12/+download/gearmand-0.12.tar.gz'
  homepage 'http://gearman.org/'
  md5 '6e88a6bfb26e50d5aed37d143184e7f2'

  depends_on 'libevent'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
