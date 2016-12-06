require 'formula'

class Alure < Formula
  homepage 'http://kcat.strangesoft.net/alure.html'
  url 'http://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2'
  md5 '3088aba074ad02d95ea51e705053b9f5'

  depends_on 'cmake' => :build
  depends_on 'libsndfile'
  depends_on 'libvorbis'
  depends_on 'flac'
  depends_on 'mpg123'

  def install
    inreplace 'CMakeLists.txt', 'PKG_CHECK_MODULES(VORBISFILE', '#PKG_CHECK_MODULES(VORBISFILE'
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
