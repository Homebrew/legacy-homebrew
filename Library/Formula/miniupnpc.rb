require 'formula'

class Miniupnpc < Formula
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.6.20120125.tar.gz'
  homepage 'http://miniupnp.free.fr'
  md5 '61f136f1302add9d89d329a6c1e338ca'

  def install
    system "make INSTALLPREFIX=#{prefix} install"
  end
end
