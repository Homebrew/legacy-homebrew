require 'formula'

class Openfst < Formula
  homepage 'http://www.openfst.org/'
  url 'http://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.3.4.tar.gz'
  sha1 '21972c05896b2154a3fa1bdca5c9a56350194b38'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
