require 'formula'

# Minecraft cartography tool

class C10t <Formula
  url 'https://github.com/udoprog/c10t/tarball/1.4'
  homepage 'https://github.com/udoprog/c10t'
  md5 '27ff806400602726e45679d444c4489d'

  depends_on 'cmake' => :build
  depends_on 'libpng'
  depends_on 'boost'

  def install
    inreplace 'src/global.hpp', "font.ttf", "#{prefix}/font.ttf"
    inreplace 'CMakeLists.txt', 'boost_thread', 'boost_thread-mt'
    inreplace 'test/CMakeLists.txt', 'boost_unit_test_framework', 'boost_unit_test_framework-mt'
    system "cmake . #{std_cmake_parameters}"
    system "make"
    bin.install "c10t"
    prefix.install "font.ttf"
  end
end
