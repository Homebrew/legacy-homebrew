require 'formula'

class Openfst < Formula
  url 'http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-1.1.tar.gz'
  homepage 'http://www.openfst.org/'
  md5 '7491c12e0878ab594cc14ae88103c486'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
