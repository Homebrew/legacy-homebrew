require "formula"

class Proverif < Formula
  homepage "http://prosecco.gforge.inria.fr/personal/bblanche/proverif"
  url "http://prosecco.gforge.inria.fr/personal/bblanche/proverif/proverif1.88pl1.tar.gz"
  sha1 "d03d63d9ad30eaec3c6f60ab187a0da6490000ca"
  version "1.88.1"

  depends_on 'objective-caml'

  def install
    system "./build"
    bin.install 'proverif','proveriftotex','spassconvert'
  end

  test do
    system "#{bin}/proverif"
  end
end
