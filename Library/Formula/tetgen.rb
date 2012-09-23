require 'formula'

class Tetgen < Formula
  homepage 'http://tetgen.org/'
  url 'http://tetgen.org/files/tetgen1.4.3.tar.gz'
  sha1 '16c6de93837a34c8661dd3bfcc8171591a93564a'

  def install
    system "make" # build the tetgen binary
    system "make tetlib" # build the library file libtet.a
    bin.install 'tetgen'
    lib.install 'libtet.a'
  end

  def test
    system "#{bin}/tetgen"
  end
end
