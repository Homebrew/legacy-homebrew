require 'formula'

class Bison < Formula
  homepage 'http://www.gnu.org/software/bison/'
  url 'http://ftpmirror.gnu.org/bison/bison-2.7.1.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bison/bison-2.7.1.tar.gz'
  sha1 '676af12f51a95390d9255ada83efa8fbb271be3a'

  keg_only :provided_by_osx, 'Some formulae require a newer version of bison.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
