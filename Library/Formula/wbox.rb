require 'formula'

class Wbox < Formula
  homepage 'http://hping.org/wbox/'
  url 'http://hping.org/wbox/wbox-5.tar.gz'
  sha1 '5f20fca378c8abf53bb6a9069ecdebeb40a74147'

  def install
    system "make"
    bin.install "wbox"
  end

  def test
    system "#{bin}/wbox", "www.google.com", "1"
  end
end
