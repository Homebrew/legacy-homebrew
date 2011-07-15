require 'formula'

class Hydra < Formula
  url 'http://www.thc.org/releases/hydra-6.5-src.tar.gz'
  homepage 'http://www.thc.org/thc-hydra/'
  md5 '69a5afbbcbe3b1fdd31f9bf616480336'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix+"man" # Put man pages in correct place
  end
end
