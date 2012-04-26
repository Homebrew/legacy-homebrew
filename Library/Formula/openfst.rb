require 'formula'

class Openfst < Formula
  homepage 'http://www.openfst.org/'
  url 'http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-1.2.10.tar.gz'
  md5 '2c73dca4cbfe3850b9b7f6988249c870'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
