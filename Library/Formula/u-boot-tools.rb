require 'formula'

class UBootTools < Formula
  homepage 'http://www.denx.de/wiki/U-Boot/'
  url 'ftp://ftp.denx.de/pub/u-boot/u-boot-2012.10.tar.bz2'
  sha1 '80bc5f6d3e518803c9320d480e693fe1cb76a494'

  def install
    system 'make tools'
    bin.install 'tools/mkimage'
    man1.install 'doc/mkimage.1'
  end
end
