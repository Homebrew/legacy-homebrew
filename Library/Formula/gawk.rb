require 'brewkit'

class Gawk <Formula
  @url='http://ftp.gnu.org/gnu/gawk/gawk-3.1.7.tar.bz2'
  @homepage='http://www.gnu.org/software/gawk/'
  @md5='674cc5875714315c490b26293d36dfcf'

  # For some reason, without this gawk (but not pgawk)
  # loses its executable bit.  I have no idea why.
  def skip_clean? path
    true
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
