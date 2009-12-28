require 'formula'

class Libtasn1 <Formula
  url 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.3.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 '4f0918cf8fe8b2b4ba189938772d1dd2'

  aka :libtasn

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
