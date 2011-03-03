require 'formula'

class Libtasn1 <Formula
  url 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.9.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 'f4f4035b84550100ffeb8ad4b261dea9'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
