require 'formula'

class Hydra < Formula
  url 'http://www.thc.org/releases/hydra-7.2-src.tar.gz'
  homepage 'http://www.thc.org/thc-hydra/'
  sha1 '1f31cc2ee3605b5e46edce48ec23f6065c8df7f1'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix+"man" # Put man pages in correct place
  end
end
