require 'formula'

class Gzrt < Formula
  homepage 'http://www.urbanophile.com/arenn/coding/gzrt/gzrt.html'
  url 'http://www.urbanophile.com/arenn/coding/gzrt/gzrt-0.6.tar.gz'
  sha1 '6b0ce648fd973771b899fa866d23c81cdf9d036e'

  def install
    system "make"
    bin.install "gzrecover"
    man1.install "gzrecover.1"
  end
end
