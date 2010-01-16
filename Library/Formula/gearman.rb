require 'formula'

class Gearman <Formula
  url 'http://launchpad.net/gearmand/trunk/0.10/+download/gearmand-0.10.tar.gz'
  homepage 'http://gearman.org/'
  md5 '74d29c260bc7096c9193d3f6af57298f'

  depends_on 'libevent'
  aka 'gearmand'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
