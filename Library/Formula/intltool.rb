require 'formula'

class Intltool <Formula
  url 'http://edge.launchpad.net/intltool/trunk/0.41.0/+download/intltool-0.41.0.tar.gz'
  homepage 'http://www.freedesktop.org/wiki/Software/intltool'
  md5 '8a6e4afd3fc93637dcd70e36ab899364'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
