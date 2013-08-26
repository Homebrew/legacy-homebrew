require 'formula'

class Pngquant < Formula
  homepage 'http://pngquant.org/'
  url 'https://github.com/pornel/pngquant/archive/2.0.0.tar.gz'
  sha1 '083746e8b15936ba2efcbd26f76f0abd930dfa03'

  head 'https://github.com/pornel/pngquant.git'

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
