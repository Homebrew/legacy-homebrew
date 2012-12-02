require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Prooftree < Formula
  homepage 'http://askra.de/software/prooftree'
  url 'http://askra.de/software/prooftree/releases/prooftree-0.10.tar.gz'
  sha1 'ac9ba265062382109673320635d822f92e6a126c'

  depends_on :x11
  depends_on 'lablgtk'

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./configure", "--prefix", "#{prefix}"
    system "make"
    system "make install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test prooftree`.
    system "false"
  end
end
