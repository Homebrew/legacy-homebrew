require 'formula'

class Nlopt < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/NLopt'
  url 'http://ab-initio.mit.edu/nlopt/nlopt-2.2.4.tar.gz'
  sha1 'a97fcffb0c3aaf57aab5aadb9487e99b09dbee54'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
