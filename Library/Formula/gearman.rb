require 'formula'

class Gearman < Formula
  url 'http://launchpad.net/gearmand/trunk/gearman-0.20/+download/gearmand-0.20.tar.gz'
  homepage 'http://gearman.org/'
  md5 '976f31a9d8b9fef5a9b635509da6d76f'

  depends_on 'libevent'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
