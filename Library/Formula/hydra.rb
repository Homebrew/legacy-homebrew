require 'formula'

class Hydra < Formula
  homepage 'http://www.thc.org/thc-hydra/'
  url 'http://www.thc.org/releases/hydra-7.4.2.tar.gz'
  sha1 '19bf40ef7d1e8b1da55d9696b3cdcc2769557904'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix/"man" # Put man pages in correct place
  end
end
