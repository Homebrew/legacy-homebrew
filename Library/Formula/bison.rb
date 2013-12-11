require 'formula'

class Bison < Formula
  homepage 'http://www.gnu.org/software/bison/'
  url 'http://ftpmirror.gnu.org/bison/bison-3.0.2.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bison/bison-3.0.2.tar.gz'
  sha1 '4bbb9a1bdc7e4328eb4e6ef2479b3fe15cc49e54'

  keg_only :provided_by_osx, 'Some formulae require a newer version of bison.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
