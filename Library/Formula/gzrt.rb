require 'formula'

class Gzrt < Formula
  desc "Gzip recovery toolkit"
  homepage 'http://www.urbanophile.com/arenn/coding/gzrt/gzrt.html'
  url 'http://www.urbanophile.com/arenn/coding/gzrt/gzrt-0.8.tar.gz'
  sha1 'a354901b7aa2192bafdc34f43fbfde3cd7de2822'

  def install
    system "make"
    bin.install "gzrecover"
    man1.install "gzrecover.1"
  end
end
