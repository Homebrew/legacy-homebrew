require 'formula'

class Bison < Formula
  homepage 'http://www.gnu.org/software/bison/'
  url 'http://ftpmirror.gnu.org/bison/bison-3.0.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/bison/bison-3.0.tar.gz'
  sha1 'e2da7ecd4ab65a12effe63ffa3ff5e7da34d9a72'

  keg_only :provided_by_osx, 'Some formulae require a newer version of bison.'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
