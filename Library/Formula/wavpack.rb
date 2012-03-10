require 'formula'

class Wavpack < Formula
  url 'http://www.wavpack.com/wavpack-4.60.1.tar.bz2'
  homepage 'http://www.wavpack.com/'
  md5 '7bb1528f910e4d0003426c02db856063'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
