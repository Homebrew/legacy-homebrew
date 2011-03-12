require 'formula'

class Gearman <Formula
  url 'http://launchpad.net/gearmand/trunk/gearman-0.16/+download/gearmand-0.16.tar.gz'
  homepage 'http://gearman.org/'
  md5 '40b37df7525345021c72bfd81cccca20'

  depends_on 'libevent'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
