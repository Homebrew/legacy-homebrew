require "formula"

class VidStab < Formula
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/release-0.98b.tar.gz"
  sha1 "1030a1baa9b2cba844758a6cd8dd5d5fc23f9cd9"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args + ["-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end
end
