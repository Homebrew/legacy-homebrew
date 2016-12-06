require 'formula'
class Tsdemux < Formula
  homepage 'https://code.google.com/p/tsdemuxer/'
  head 'http://tsdemuxer.googlecode.com/svn/trunk/', :using => :svn

  def install
    system "make"
    bin.install "tsdemux"
  end

  def test
    system "#{bin}/tsdemux"
  end
end
