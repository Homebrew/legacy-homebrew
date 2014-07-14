require 'formula'

class Mbelib < Formula
  homepage 'https://github.com/szechyjs/mbelib'
  url  'https://github.com/szechyjs/mbelib/archive/v1.2.5.tar.gz'
  sha1 'ee970823d95f008941132edc6142a1a0282655a8'
  head 'https://github.com/szechyjs/mbelib.git'

  bottle do
    cellar :any
    sha1 "8397b4aa2db9aa259708aaeacab53ce2b0699b93" => :mavericks
    sha1 "81a0d6bbdfbb56ae25ea9f4a5e7691914b1afafd" => :mountain_lion
    sha1 "a907d1bb374da4629c30219bf22392ec6a7afebd" => :lion
  end

  depends_on 'cmake' => :build

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
