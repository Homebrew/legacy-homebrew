require 'formula'

class Hydra < Formula
  url 'http://www.thc.org/releases/hydra-7.1-src.tar.gz'
  homepage 'http://www.thc.org/thc-hydra/'
  md5 '0c3a6a351cb2e233cb989f0bcdd75edf'

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    system "make all install"
    share.install prefix+"man" # Put man pages in correct place
  end
end
