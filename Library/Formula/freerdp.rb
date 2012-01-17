require 'formula'

class Freerdp < Formula
  homepage 'http://www.freerdp.com/'
  head 'git://github.com/FreeRDP/FreeRDP.git'
  url 'https://github.com/FreeRDP/FreeRDP/tarball/1.0.0'
  md5 '53b0a12c367b9b3a8dbe60e7fa0f88e9'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
