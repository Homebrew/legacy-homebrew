require 'formula'

class Intltool < Formula
  homepage 'http://www.freedesktop.org/wiki/Software/intltool'
  url 'http://edge.launchpad.net/intltool/trunk/0.41.1/+download/intltool-0.41.1.tar.gz'
  md5 'd6c91bf06681919ccfdf3624035b75dc'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
