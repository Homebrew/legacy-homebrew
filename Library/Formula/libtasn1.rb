require 'formula'

class Libtasn1 <Formula
  url 'http://ftp.gnu.org/gnu/libtasn1/libtasn1-2.8.tar.gz'
  homepage 'http://www.gnu.org/software/libtasn1/'
  md5 '53fd164f8670e55a9964666990fb358f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
