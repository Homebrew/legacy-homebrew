require 'formula'

class Mbelib < Formula
  homepage 'https://github.com/szechyjs/mbelib'
  url  'https://github.com/szechyjs/mbelib/archive/v1.2.5.tar.gz'
  sha1 'ee970823d95f008941132edc6142a1a0282655a8'
  head 'https://github.com/szechyjs/mbelib.git'

  bottle do
    cellar :any
    revision 1
    sha1 "ce1b002a5de2daeb6a0f3c191354b23989ce64dc" => :yosemite
    sha1 "67706f7658034d8894a3bc8e86d79857dc4472d1" => :mavericks
    sha1 "979a2c63f3e44231ddf6e7b8829721a0e0a3c2bc" => :mountain_lion
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
