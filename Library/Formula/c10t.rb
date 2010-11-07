require 'formula'

# Minecraft cartography tool

class C10t <Formula
  url 'http://github.com/udoprog/c10t/tarball/1.2'
  homepage 'http://github.com/udoprog/c10t'
  md5 'c8f1cc003675d30b42cf9356476d8714'

  depends_on 'cmake' => :build
  depends_on 'libpng'
  depends_on 'boost'

  def install
    inreplace 'src/global.h', "font.ttf", "#{prefix}/font.ttf"
    inreplace 'CMakeLists.txt', 'boost_thread', 'boost_thread-mt'
    inreplace 'test/CMakeLists.txt', 'boost_unit_test_framework', 'boost_unit_test_framework-mt'
    system "cmake . #{std_cmake_parameters}"
    system "make"
    bin.install "c10t"
    prefix.install "font.ttf"
  end
end
