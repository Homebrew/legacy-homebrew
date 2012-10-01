require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Levmar < Formula
  homepage 'http://www.ics.forth.gr/~lourakis/levmar/'
  url 'http://www.ics.forth.gr/~lourakis/levmar/levmar-2.6.tgz'
#  version '2.6'
  sha1 '118bd20b55ab828d875f1b752cb5e1238258950b'

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    inreplace 'Makefile', '-lf2c',''
    system "make"
    include.install "levmar.h"
    lib.install "liblevmar.a"
    bin.install "lmdemo"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test levmar`.
    system "#{bin}/lmdemo"
  end
end
