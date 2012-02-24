require 'formula'

class Libechonest < Formula
  url 'http://pwsp.cleinias.com/libechonest-1.2.1.tar.bz2'
  homepage 'https://projects.kde.org/projects/playground/libs/libechonest'
  sha1 '5ad5897c91c365b32840e75e806c9725c89b4522'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'qjson'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
