require 'formula'

class Miniupnpc < Formula
  url 'http://miniupnp.free.fr/files/miniupnpc-1.6.20120121.tar.gz'
  homepage 'http://miniupnp.free.fr/'
  md5 'd818a22bc19e58a571c2d27dc0d4835a'

  def install
    system "make INSTALLPREFIX=#{prefix} install"
  end
end
