require 'formula'

class Readline5 <Formula
  url 'ftp://ftp.gnu.org/gnu/readline/readline-5.1.tar.gz'
  homepage 'http://tiswww.case.edu/php/chet/readline/rltop.html'
  md5 '7ee5a692db88b30ca48927a13fd60e46'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
