require "formula"

class Enki < Formula
  homepage "http://home.gna.org/enki"
  url "https://github.com/enki-community/enki/archive/2.0-pre.20140520.tar.gz"
  sha1 "342ca29c8317a22098d6c6834f8d565c30dc46eb"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "sdl"
  depends_on :python2 => :optional
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args, "-DPYTHON_CUSTOM_TARGET=#{prefix}/lib/python2.7/site-packages"
    system "make", "install"
    (share+"test").install "examples/enkiTest"
  end

  test do
    system "#{share}/test/enkiTest"
  end
end
