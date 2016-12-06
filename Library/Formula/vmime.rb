require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Vmime < Formula
  homepage 'http://www.vmime.org/'
  url 'https://github.com/kisli/vmime/archive/099d7a7882fa5cdade61c0b8e10b4d6be8b24488.tar.gz'
  version '0.9.2svn'
  sha1 'a8fdd9f2418c2c1dac8f3ab037992efffaaa60f7'

  depends_on 'cmake' => :build
  depends_on 'libgsasl'
  depends_on 'gnutls'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "cmake", ".", *std_cmake_args
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test vmime`.
    system "false"
  end
end
