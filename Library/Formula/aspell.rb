require 'brewkit'

class Aspell <Formula
  url 'ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.tar.gz'
  homepage 'http://aspell.net/'
  md5 'bc80f0198773d5c05086522be67334eb'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
