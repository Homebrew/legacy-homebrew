require 'formula'

class Gearman <Formula
  url 'http://launchpad.net/gearmand/trunk/0.15/+download/gearmand-0.15.tar.gz'
  homepage 'http://gearman.org/'
  md5 'd394214d3cddc5af237d73befc7e3999'

  depends_on 'libevent'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
