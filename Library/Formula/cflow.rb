require 'formula'

class Cflow < Formula
  url 'http://ftp.gnu.org/gnu/cflow/cflow-1.3.tar.bz2'
  homepage 'http://www.gnu.org/software/cflow/'
  md5 'b3fe4bfba9d648447065b3c2d73ae66c'

  def install
    ENV.append "CFLAGS", " -fno-common"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--infodir=#{info}"
    system "make install"
  end
end
