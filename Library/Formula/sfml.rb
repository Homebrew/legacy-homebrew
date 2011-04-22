require 'formula'

class Sfml < Formula
  url 'https://github.com/LaurentGomila/SFML/tarball/master'
  homepage 'http://www.sfml-dev.org/'
  version '2.0'
  md5 '378078bf44c690d170d2b37174efa458'

  depends_on 'cmake' => :build
  depends_on 'jpeg'
  depends_on 'glew'
  depends_on 'libsndfile'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make"
    system "make install"
  end
end
