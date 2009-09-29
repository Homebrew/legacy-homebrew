require 'brewkit'

class Gawk <Formula
  @url='http://ftp.gnu.org/gnu/gawk/gawk-3.1.7.tar.bz2'
  @homepage='http://www.gnu.org/software/gawk/'
  @md5='674cc5875714315c490b26293d36dfcf'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
