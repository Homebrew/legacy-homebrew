require 'formula'

class Pngquant < Formula
  homepage 'http://pngquant.org/'
  url 'https://github.com/pornel/improved-pngquant/tarball/1.8.1'
  sha1 'c29e14e9d554b0906259bb2f51954661cf336084'

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
