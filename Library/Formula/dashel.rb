require "formula"

class Dashel < Formula
  homepage "https://github.com/aseba-community/dashel"
  url "https://github.com/aseba-community/dashel/archive/1.0.8.2.tar.gz"
  sha1 "40db2b76a62c743fbbccc2d6d425cc7479a9dcac"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    (share+"test").install "portlist"
  end

  test do
    system "#{share}/test/portlist"
  end
end
