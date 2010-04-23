require 'formula'

class Libarchive <Formula
  url 'http://libarchive.googlecode.com/files/libarchive-2.8.3.tar.gz'
  homepage 'http://code.google.com/p/libarchive/'
  md5 'fe8d917e101d4b37580124030842a1d0'

# depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
