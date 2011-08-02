require 'formula'

class Svdlibc < Formula
  url 'http://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz'
  homepage 'http://tedlab.mit.edu/~dr/SVDLIBC/'
  md5 '0e1b3bc149f1da476fd81c58742b5ee9'
  version '1.34'

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make HOSTTYPE=target"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
