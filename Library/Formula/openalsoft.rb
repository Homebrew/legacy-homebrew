require "formula"

class Openalsoft < Formula
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.15.1.tar.bz2"
  sha1 "a0e73a46740c52ccbde38a3912c5b0fd72679ec8"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
