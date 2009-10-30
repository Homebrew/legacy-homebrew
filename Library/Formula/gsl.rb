require 'formula'

# TODO alias GNU Scientific Library

class Gsl <Formula
  url 'ftp://ftp.gnu.org/gnu/gsl/gsl-1.13.tar.gz'
  homepage 'http://www.gnu.org/software/gsl/'
  md5 'd9fcfa367c44ab68a25b4edf34c3c5f7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make" # A GNU tool which doesn't support just make install! Shameful!
    system "make install"
  end
end
