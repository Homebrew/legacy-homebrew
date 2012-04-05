require 'formula'

class Alure < Formula
  url 'http://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2'
  homepage 'http://kcat.strangesoft.net/alure.html'
  md5 '3088aba074ad02d95ea51e705053b9f5'

  all = ARGV.include?('--all')

  depends_on 'cmake'
  depends_on 'libvorbis' if ARGV.include?('--with-libvorbis') || all
  depends_on 'libogg'    if ARGV.include?('--with-libogg')    || all
  depends_on 'libsndfile'if ARGV.include?('--with-libsndfile')|| all
  depends_on 'flac'      if ARGV.include?('--with-flac')      || all
  depends_on 'mpg123'    if ARGV.include?('--with-mpg123')    || all
  depends_on 'fluidsynth'if ARGV.include?('--with-fluidsynth')|| all

  def install
    cd "build" do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end
  end
end
