require 'formula'

class GnuTime <Formula
  url 'http://ftp.gnu.org/gnu/time/time-1.7.tar.gz'
  homepage 'http://www.gnu.org/software/time/'
  md5 'e38d2b8b34b1ca259cf7b053caac32b3'

  def install
    system "./configure",
    "--prefix=#{prefix}",
    "--program-prefix=g",
    "--mandir=#{man}"
    system "make install"
  end
end
