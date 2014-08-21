require "formula"

class Dashel < Formula
  homepage "https://github.com/aseba-community/dashel"
  url "https://github.com/aseba-community/dashel/archive/1.0.8.tar.gz"
  sha1 "ea93321250c4bb32c48e7fecf72554a068d64192"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{buildpath}/portlist"
  end
end
