require 'formula'

class Libechonest < Formula
  url 'http://pwsp.cleinias.com/libechonest-1.1.8.tar.bz2'
  homepage 'https://projects.kde.org/projects/playground/libs/libechonest'
  sha1 'ce79da389979e7deca2858b1d677312f027b6264'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'qjson'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
