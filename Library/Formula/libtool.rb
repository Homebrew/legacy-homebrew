require 'formula'

class Libtool <Formula
  url 'http://ftp.gnu.org/gnu/libtool/libtool-2.2.tar.gz'
  homepage 'http://www.gnu.org/software/libtool/'
  md5 '217e9ec3e3cbdf891cbd4772140964a1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
