require "formula"

class Dashel < Formula
  homepage "https://github.com/aseba-community/dashel"
  url "https://github.com/aseba-community/dashel/archive/1.0.8.tar.gz"
  sha1 "ea93321250c4bb32c48e7fecf72554a068d64192"

  depends_on "cmake" => :build

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
	"-DCMAKE_BUILD_TYPE=Release",
	"-DCMAKE_FIND_FRAMEWORK=LAST",
	"-DCMAKE_VERBOSE_MAKEFILE=ON",
	"-Wno-dev"]
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    system "#{buildpath}/portlist"
  end
end
