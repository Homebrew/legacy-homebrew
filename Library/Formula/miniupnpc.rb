require 'formula'

class Miniupnpc < Formula
  url 'http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.6.tar.gz'
  homepage 'http://miniupnp.free.fr'
  md5 '88055f2d4a061cfd4cfe25a9eae22f67'

  depends_on 'cmake'

  def install
    system "make INSTALLPREFIX=#{prefix} install"
  end

  def test
    return `which upnpc`.strip != ""
  end
end
