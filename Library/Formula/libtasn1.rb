require 'formula'

class Libtasn1 <Formula
  url 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.5.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 'e60b863697713c3d6a59b1e8c6f9b0d1'

  aka :libtasn

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
