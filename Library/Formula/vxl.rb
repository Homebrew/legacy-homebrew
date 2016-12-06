require 'formula'

class Vxl <Formula
  url 'http://sourceforge.net/projects/vxl/files/vxl/1.14/vxl-1.14.0.zip'
  homepage 'http://vxl.sourceforge.net/'
  md5 '0329521f2fda61d2835e7b3c7c1189df'
  version '1.14.0'

  depends_on 'cmake'

  def install
    system "cmake -D BUILD_CORE_SERIALISATION:BOOL=OFF -D BUILD_CORE_UTILITIES:BOOL=OFF -D BUILD_CORE_GEOMETRY:BOOL=OFF -D BUILD_CONTRIB:BOOL=OFF -D BUILD_TESTING:BOOL=OFF -D BUILD_EXAMPLES:BOOL=OFF #{std_cmake_parameters} . "

    system "make install"
  end
end
