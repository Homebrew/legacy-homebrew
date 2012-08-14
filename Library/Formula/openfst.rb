require 'formula'

class Openfst < Formula
  homepage 'http://www.openfst.org/'
  url 'http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-1.3.2.tar.gz'
  sha1 'b172439a9fcd5b8d4285a04d99d90e69cd7d12e9'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
