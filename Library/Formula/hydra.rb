require 'formula'

class Hydra < Formula
  homepage 'http://www.thc.org/thc-hydra/'
  url 'http://www.thc.org/releases/hydra-7.6.tar.gz'
  sha1 '7df230bb4f228a5cdc776ef1a215a1523b58f40b'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix/"man" # Put man pages in correct place
  end
end
