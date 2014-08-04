require 'formula'

class Svdlibc < Formula
  homepage 'http://tedlab.mit.edu/~dr/SVDLIBC/'
  url 'http://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz'
  version '1.4'
  sha1 '9243fbc0516af42b020423442212a025b3406dac'

  bottle do
    cellar :any
    revision 1
    sha1 "8cb13d197689b2fb40b939ff1346ea86e6e94a8a" => :mavericks
    sha1 "21889860321bb5593fe0125c4e9ffa4e0fdd1805" => :mountain_lion
    sha1 "53cd8f618f8b37eddff753fa2d2d347c93f07953" => :lion
  end

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make HOSTTYPE=target"
    include.install "svdlib.h"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
