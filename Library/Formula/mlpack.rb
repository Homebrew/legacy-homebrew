require "formula"

class Mlpack < Formula
  homepage "http://www.mlpack.org"
  url "http://www.mlpack.org/files/mlpack-1.0.8.tar.gz"
  sha1 "f7fce9d37964fb6ede017d29799155f0a08a3e0e"

  depends_on "cmake" => :build
  depends_on "lapack"
  depends_on "armadillo"
  depends_on "libxml2"
  depends_on "boost"

  option "with-debug", "Compile with debug options"
  option "with-profile", "Compile with profile options"

  def install
    ENV.cxx11 if build.cxx11?
    cmake_args = ""
    cmake_args += "-D DEBUG=OFF " if not build.include? "with-debug"
    cmake_args += "-D PROFILE=OFF " if not build.include? "with-profile"
    system "cmake", cmake_args, ".", *std_cmake_args
    system "make install"
  end
end
