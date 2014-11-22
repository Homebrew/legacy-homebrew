require "formula"

class Assimp < Formula
  homepage "http://assimp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/assimp/assimp-3.1/assimp-3.1.1_no_test_models.zip"
  sha1 "d7bc1d12b01d5c7908d85ec9ff6b2d972e565e2d"
  version "3.1.1"

  head "https://github.com/assimp/assimp.git"

  bottle do
    cellar :any
    sha1 "0b103054733c3791ad92cdb51b0acd7e053baf61" => :yosemite
    sha1 "a34746e16ce3ec4d5737db73db1ddd766d688619" => :mavericks
    sha1 "7a0bb7602c85f83cb775a95bfe384bf8a5ca4283" => :mountain_lion
  end

  option "without-boost", "Compile without thread safe logging or multithreaded computation if boost isn't installed"

  depends_on "cmake" => :build
  depends_on "boost" => :recommended

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
