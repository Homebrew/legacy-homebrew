require 'formula'

class Zopfli < Formula
  homepage 'http://googledevelopers.blogspot.com/2013/02/compress-data-more-densely-with-zopfli.html'
  version "0.1"
  head 'https://code.google.com/p/zopfli/', :using => :git



  def install
    system "make"
    system "chmod +x zopfli"
    bin.install "zopfli"
  end

  test do
    system "zopfli"
  end
end
