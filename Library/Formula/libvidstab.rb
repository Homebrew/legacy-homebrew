require "formula"

class Libvidstab < Formula
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz"
  sha1 "1030a1baa9b2cba844758a6cd8dd5d5fc23f9cd9"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
