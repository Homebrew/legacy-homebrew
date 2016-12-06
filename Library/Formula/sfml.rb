require 'formula'

class Sfml < Formula
  homepage 'http://www.sfml-dev.org/'
  head 'https://github.com/LaurentGomila/SFML.git'

  depends_on 'cmake' => :build
  depends_on 'libsndfile' => :build

  def install
    system "cmake . -DCMAKE_INSTALL_FRAMEWORK_PREFIX=#{prefix} #{std_cmake_parameters}"
    system "make install"
  end
end
