require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Pplatex < Formula
  homepage 'http://www.stefant.org/web/projects/software/pplatex.html'
  url 'http://dl.dropbox.com/u/12697903/pplatex/pplatex-1.0-rc1-src.tar.gz'
  #version '1.0'
  sha1 'd437c64a8263eeb45ded4f57df8cce29080a92d0'

  depends_on 'scons' => :build
  depends_on 'pcre'

  def install
    system 'scons'
    bin.install('bin/pplatex')
    bin.install('bin/ppdflatex')
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test pplatex`.
    system "pplatex -h"
  end
end
