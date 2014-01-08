require 'formula'

class Morse < Formula
  homepage 'http://www.catb.org/~esr/morse/'
  url 'http://www.catb.org/~esr/morse/morse-2.5.tar.gz'
  sha1 'f3b607272e5dc84920e4d3a80d559df0e92ec54b'

  depends_on :x11

  def install
    system "make", "all", "DEVICE=X11"
    bin.install "morse"
    man1.install "morse.1"
  end
end
