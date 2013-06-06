require 'formula'

class Svdlibc < Formula
  homepage 'http://tedlab.mit.edu/~dr/SVDLIBC/'
  url 'http://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz'
  version '1.4'
  sha1 '9243fbc0516af42b020423442212a025b3406dac'

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make HOSTTYPE=target"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
