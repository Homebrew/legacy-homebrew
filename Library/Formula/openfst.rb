require "formula"

class Openfst < Formula
  homepage 'http://www.openfst.org/'
  url "http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-1.4.1.tar.gz"
  sha1 "2e5ff58c7c70e681bced49206bd81748eeb7106d"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-far",
                          "--enable-pdt"
    system "make install"
  end
end
