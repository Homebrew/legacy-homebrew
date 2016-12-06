require 'formula'

class Mpclib < Formula
  depends_on 'gmp' 
  depends_on 'mpfr'
  url 'http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz'
  homepage 'http://www.multiprecision.org/'
  md5 'e98267ebd5648a39f881d66797122fb6'
  def install
    system "./configure", "--disable-dependency-tracking",
            "--prefix=#{prefix}", "--infodir=#{info}", "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
