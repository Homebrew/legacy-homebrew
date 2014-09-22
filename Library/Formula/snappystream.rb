require "formula"

class Snappystream < Formula
  homepage "https://github.com/hoxnox/snappystream"
  url "https://github.com/hoxnox/snappystream/archive/0.1.tar.gz"
  sha1 "50d97c8d9899fc63d3ff386d40779f400c912bb4"

  head 'https://github.com/hoxnox/snappystream.git'

  depends_on "cmake" => :build
  depends_on 'snappy'

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end
