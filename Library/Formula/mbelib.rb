require 'formula'

class Mbelib < Formula
  homepage 'https://github.com/szechyjs/mbelib'
  head 'https://github.com/szechyjs/mbelib.git'
  url  'https://github.com/szechyjs/mbelib/archive/v1.2.5.tar.gz'
  sha1 'ee970823d95f008941132edc6142a1a0282655a8'

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
