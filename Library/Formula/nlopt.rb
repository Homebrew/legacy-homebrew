require 'formula'

class Nlopt < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/NLopt'
  url 'http://ab-initio.mit.edu/nlopt/nlopt-2.4.tar.gz'
  sha1 'e766f4c49fa5923fb45220f278c01c04c38fc369'

  option :cxx11

  def install
    ENV.cxx11 if build.cxx11?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
