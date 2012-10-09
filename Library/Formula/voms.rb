require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Voms < Formula
  homepage 'https://github.com/italiangrid/voms'
  url 'https://github.com/italiangrid/voms/tarball/2_0_8'
#  version '2.0.8'
  sha1 '5dcdbea034152b02646a4aecaafb6888a71b22ed'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "sh autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test voms`.
    system "false"
  end
end
