require 'formula'

class Tetgen < Formula
  homepage 'http://tetgen.org/'
  url 'http://tetgen.org/files/tetgen1.4.3.tar.gz'
  md5 'd6a4bcdde2ac804f7ec66c29dcb63c18'

  def install
    system "make" # build the tetgen binary
    system "make tetlib" # build the library file libtet.a
    bin.install 'tetgen'
    lib.install 'libtet.a'
  end

  def test
    # Run the test with `brew test tetgen`.
    system "tetgen"
  end
end
