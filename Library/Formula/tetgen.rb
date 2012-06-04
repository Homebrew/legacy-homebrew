require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

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
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test tetgen`.
    system "tetgen"
  end
end
