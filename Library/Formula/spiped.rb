require 'formula'

class Spiped < Formula
  homepage 'http://www.tarsnap.com/spiped.html'
  url 'https://www.tarsnap.com/spiped/spiped-1.2.0.tgz'
  sha256 '46fb94da62bf1f074513047519f2d4f5faf103e5b8555e14a375a42b74508a6b'

  depends_on :bsdmake

  def patches
    # - Include ``stdint.h'' for ``uint8_t'' definition.
    # - Remove unconditional ``librt'' from LDADD.
    "https://raw.github.com/gist/3541617/e212734f3ff105f636ea6e225ad7c9d5cb0ce347/spiped-1.2.0-macosx-mountain-lion.patch"
  end

  def install
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "install"
  end
end
