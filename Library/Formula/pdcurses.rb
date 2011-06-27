require 'formula'

class Pdcurses < Formula
  url 'http://sourceforge.net/projects/pdcurses/files/pdcurses/3.4/PDCurses-3.4.tar.gz'
  homepage 'http://sourceforge.net/projects/pdcurses/'
  md5 '4e04e4412d1b1392a7f9a489b95b331a'


  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
