require 'formula'

class Libtasn1 < Formula
  homepage 'http://www.gnu.org/software/libtasn1/'
  url 'http://ftpmirror.gnu.org/libtasn1/libtasn1-2.12.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.12.tar.gz'
  md5 '4eba39fb962d6cf5a370267eae8ff52b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
