require 'formula'

class Nlopt < Formula
  homepage 'http://ab-initio.mit.edu/wiki/index.php/NLopt'
  url 'http://ab-initio.mit.edu/nlopt/nlopt-2.2.4.tar.gz'
  md5 '9c60c6380a10c6d2a06895f0e8756d4f'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
