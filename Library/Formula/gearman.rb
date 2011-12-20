require 'formula'

class Gearman < Formula
  url 'http://launchpad.net/gearmand/trunk/0.26/+download/gearmand-0.26.tar.gz'
  homepage 'http://gearman.org/'
  md5 '52a8cc98f649980331cc8011d47af09f'

  depends_on 'libevent'
  depends_on 'boost'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
