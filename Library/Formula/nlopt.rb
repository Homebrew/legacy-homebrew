require 'formula'

class Nlopt < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/NLopt'
  url 'http://ab-initio.mit.edu/nlopt/nlopt-2.3.tar.gz'
  sha1 '28253b65187d9d1d4c75e96310d8ee8c9c5f3cfc'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
