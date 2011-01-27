require 'formula'

class Detail?name=libproxy <Formula
  url 'http://code.google.com/p/libproxy/downloads/detail?name=libproxy-0.4.6.tar.gz'
  homepage ''
  md5 ''

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
