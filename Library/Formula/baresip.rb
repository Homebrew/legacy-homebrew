require 'formula'

class Baresip < Formula
  homepage 'http://www.creytiv.com/baresip.html'
  url 'http://www.creytiv.com/pub/baresip-0.4.2.tar.gz'
  sha1 '7e7745648540cb08d45d74b57452ecfb707bb76a'
  depends_on 'librem' => :build

  def install
    system "make"
    system "make install"
  end

  def test
    system "baresip"
  end
end
