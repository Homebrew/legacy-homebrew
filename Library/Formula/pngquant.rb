require 'formula'

class Pngquant < Formula
  homepage 'http://pngquant.org/'
  url 'https://github.com/pornel/improved-pngquant/tarball/1.7.2'
  sha1 'fcb10d23380824451371f47a62428ce496f21636'

  head 'https://github.com/pornel/improved-pngquant.git'

  depends_on :libpng

  def install
    ENV.append_to_cflags "-DNDEBUG" # Turn off debug
    system "make", "PREFIX=#{prefix}", "CC=#{ENV.cc}"
    bin.install 'pngquant'
    man1.install 'pngquant.1'
  end

  def test
    system "#{bin}/pngquant", "--help"
  end
end
