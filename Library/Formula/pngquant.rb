require 'formula'

class Pngquant < Formula
  homepage 'http://pngquant.org/'
  head 'https://github.com/pornel/improved-pngquant.git'
  url 'https://github.com/pornel/improved-pngquant/tarball/1.7.2'
  sha1 'fcb10d23380824451371f47a62428ce496f21636'

  depends_on :x11

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'pngquant'
  end

  def test
    system "#{bin}/pngquant", "--help"
  end
end
