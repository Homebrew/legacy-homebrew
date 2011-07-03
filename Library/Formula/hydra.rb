require 'formula'

class Hydra < Formula
  url 'http://www.thc.org/releases/hydra-6.4-src.tar.gz'
  homepage 'http://www.thc.org/thc-hydra/'
  md5 '4592be3ef50edd608fd066e5ac8c46a1'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix+"man" # Put man pages in correct place
  end
end
