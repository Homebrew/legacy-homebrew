require 'formula'

# Minecraft cartography tool

class C10t <Formula
  url 'http://github.com/udoprog/c10t/tarball/1.3'
  homepage 'http://github.com/udoprog/c10t'
  md5 '8e5dba0375275cf6f2ce56ee052db7d2'

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
