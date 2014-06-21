require "formula"

class Libcloth < Formula
  homepage "https://github.com/fcvarela/libcloth"
  url "https://github.com/fcvarela/libcloth/archive/release/0.1.tar.gz"
  sha1 "e0ce91cede6d0eb17d3c51085aeabf94c30f8d90"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "false"
  end
end

