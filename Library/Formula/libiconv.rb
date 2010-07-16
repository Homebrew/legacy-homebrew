require 'formula'

class Libiconv <Formula
  url 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  homepage 'http://www.gnu.org/software/libiconv/'
  md5 '7ab33ebd26687c744a37264a330bbe9a'

 depends_on 'pkg-config'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
