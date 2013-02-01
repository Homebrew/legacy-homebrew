require 'formula'

class Prooftree < Formula
  homepage 'http://askra.de/software/prooftree'
  url 'http://askra.de/software/prooftree/releases/prooftree-0.10.tar.gz'
  sha1 'ac9ba265062382109673320635d822f92e6a126c'

  depends_on :x11
  depends_on 'lablgtk'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  def test
    system "prooftree -help"
  end
end
