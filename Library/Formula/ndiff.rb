require 'formula'

class Ndiff < Formula
  homepage 'http://www.math.utah.edu/~beebe/software/ndiff/'
  url 'ftp://ftp.math.utah.edu/pub/misc/ndiff-2.00.tar.gz'
  md5 '885548b4dc26e72c5455bebb5ba6c16d'

  def install
    ENV.j1

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "install", "-d", "#{prefix}/bin"
    system "install", "-d", "#{prefix}/man"
    system "install", "-d", "#{prefix}/man/man1"
    system "install", "-d", "#{prefix}/share/man"
    system "install", "-d", "#{prefix}/share/man/man1"
    system "make install"
    system "mv", "#{prefix}/man/man1/ndiff.1", "#{man}/man1/ndiff.1"
    system "rmdir", "#{prefix}/man/man1"
    system "rmdir", "#{prefix}/man"
  end

  def test
    system "ndiff --help"
  end
end
