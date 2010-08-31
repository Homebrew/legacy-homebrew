require 'formula'

class Libtasn1 <Formula
  url 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.7.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 'fade9f961ec7084dd91a9ba409ba7ab1'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
