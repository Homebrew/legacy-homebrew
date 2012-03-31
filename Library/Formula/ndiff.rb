require 'formula'

class Ndiff < Formula
  homepage 'http://www.math.utah.edu/~beebe/software/ndiff/'
  url 'ftp://ftp.math.utah.edu/pub/misc/ndiff-2.00.tar.gz'
  md5 '885548b4dc26e72c5455bebb5ba6c16d'

  def install
    ENV.j1

    system "./configure", "--prefix=.", "--mandir=."
    system "install -d bin"
    system "install -d man/man1"
    system "make install"
    bin.install "bin/ndiff"
    man1.install "man/man1/ndiff.1"
  end

  def test
    system "ndiff --help"
  end
end
