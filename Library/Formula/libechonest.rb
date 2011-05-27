require 'formula'

class Libechonest < Formula
  url 'http://pwsp.cleinias.com/libechonest-1.1.5.tar.bz2'
  homepage 'https://projects.kde.org/projects/playground/libs/libechonest'
  md5 'dfee05ea5dd58b320fce015bf5cb32e5'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'qjson'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
