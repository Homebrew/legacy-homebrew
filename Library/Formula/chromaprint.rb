require 'formula'

class Chromaprint < Formula
  url 'https://github.com/downloads/lalinsky/chromaprint/chromaprint-0.5.tar.gz'
  homepage 'http://acoustid.org/chromaprint'
  md5 '59c7b54b7d0b814a0cee593c8ef1d5fd'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
