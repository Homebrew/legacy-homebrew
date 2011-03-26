require 'formula'

class Hydra < Formula
  url 'http://freeworld.thc.org/releases/hydra-5.9.1-src.tar.gz'
  homepage 'http://freeworld.thc.org/thc-hydra/'
  md5 '6ec19a3125891267a4ac856b2afe15b6'

  def install
    system "./configure", "--disable-xhydra", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    bin.mkpath
    system "make install"
  end
end
