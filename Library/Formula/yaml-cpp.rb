require 'formula'

class YamlCpp <Formula
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.2.5.tar.gz'
  homepage 'http://code.google.com/p/yaml-cpp/'
  md5 'b17dc36055cd2259c88b2602601415d9'

  depends_on 'cmake'
  depends_on 'libyaml'

  def install

    # Fix for building on 10.6
    # See: http://code.google.com/p/yaml-cpp/issues/detail?id=68 (Fixed in revision r363)
    inreplace 'src/token.h', '<ios>', '<iostream>'

    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
