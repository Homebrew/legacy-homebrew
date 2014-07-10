require 'formula'

class Svdlibc < Formula
  homepage 'http://tedlab.mit.edu/~dr/SVDLIBC/'
  url 'http://tedlab.mit.edu/~dr/SVDLIBC/svdlibc.tgz'
  version '1.4'
  sha1 '9243fbc0516af42b020423442212a025b3406dac'

  bottle do
    cellar :any
    sha1 "b93902dd89836e59cb7a6600e43fd2619bce394b" => :mavericks
    sha1 "ba72d568aa8b662c76e605936b090fda46f9e57a" => :mountain_lion
    sha1 "e5863640f3112e1c35bae03f1dbbc1360f6e0a7e" => :lion
  end

  def install
    # make only builds - no configure or install targets, have to copy files manually
    system "make HOSTTYPE=target"
    lib.install "target/libsvd.a"
    bin.install "target/svd"
  end
end
