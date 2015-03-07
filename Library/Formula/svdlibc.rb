require 'formula'

class Svdlibc < Formula
  homepage 'http://tedlab.mit.edu/~dr/SVDLIBC/'
  url 'http://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz'
  version '1.4'
  sha1 '9243fbc0516af42b020423442212a025b3406dac'

  bottle do
    cellar :any
    revision 2
    sha1 "108aa560888b8b759a7e0da243397917da52b143" => :yosemite
    sha1 "af943e46846a41be5c039c3d825003c30e2632d4" => :mavericks
    sha1 "3a2b0a33888f387d531fc4a0f7de1d9ad370e5f5" => :mountain_lion
  end

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make HOSTTYPE=target"
    include.install "svdlib.h"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
