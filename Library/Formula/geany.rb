require 'formula'

class Geany <Formula
  url 'http://download.geany.org/geany-0.19.tar.gz'
  homepage 'http://www.geany.org/Main/HomePage'
  md5 '727cec2936846850bb088b476faad5f2'

# depends_on 'cmake'
  depends_on 'gettext' 

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
#   system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
