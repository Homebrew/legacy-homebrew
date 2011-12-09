require 'formula'

class Miniupnpc < Formula
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.5.tar.gz'
  homepage 'http://miniupnp.free.fr'
  md5 'ac3b97f2a517d5d23ef985e6122a7837'

  def install
    system "make INSTALLPREFIX=#{prefix} install"
  end
end
