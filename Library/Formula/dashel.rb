require "formula"

class Dashel < Formula
  homepage "https://github.com/aseba-community/dashel"
  url "https://github.com/aseba-community/dashel/archive/1.0.8.1.tar.gz"
  sha1 "2bb73e05e297fd82067515e57a053e2860b0260e"

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
