require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GpawSetups < Formula
  homepage 'https://wiki.fysik.dtu.dk/gpaw/'
  url 'https://wiki.fysik.dtu.dk/gpaw-files/gpaw-setups-0.9.9672.tar.gz'
  sha1 'f48a98b92e2f31dee21ce487a5f112a7ada06af6'

  def install
    Dir.mkdir 'gpaw-setups'
    system 'mv *.gz *.pckl gpaw-setups'
    share.mkpath
    share.install Dir['*']
    ENV.j1  # if your formula's build system can't parallelize
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test gpaw-setups`.
    system "true"
  end
end
