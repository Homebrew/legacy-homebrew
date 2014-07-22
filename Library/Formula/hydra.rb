require 'formula'

class Hydra < Formula
  homepage 'http://www.thc.org/thc-hydra/'
  url 'http://www.thc.org/releases/hydra-8.0.tar.gz'
  sha1 'd1a705985846caf77c291461f391a43457cc76e5'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix/"man" # Put man pages in correct place
  end
end
