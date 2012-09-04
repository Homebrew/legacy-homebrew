require 'formula'

class Wavpack < Formula
  url 'http://www.wavpack.com/wavpack-4.60.1.tar.bz2'
  homepage 'http://www.wavpack.com/'
  sha1 '003c65cb4e29c55011cf8e7b10d69120df5e7f30'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
