require 'formula'

class Openfst < Formula
  homepage 'http://www.openfst.org/'
  url 'http://openfst.cs.nyu.edu/twiki/pub/FST/FstDownload/openfst-1.3.3.tar.gz'
  sha1 'd265fab57dd54c65bf200dd382afb490f2551c7d'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
