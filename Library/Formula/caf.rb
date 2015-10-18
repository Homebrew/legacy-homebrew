class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.14.2.tar.gz"
  sha256 "5d7fadee7c6af2ad2eb9cb66cf2a6109c72f47652b7e3f0c01a267d3dfb99290"
  head "https://github.com/actor-framework/actor-framework.git",
    :branch => "develop"

  bottle do
    cellar :any
    sha256 "5b0d8d5b21051111480c9213132570c2d8c944b00a2ef1c21ba7338777a9d9d9" => :el_capitan
    sha256 "e247d4384eccd86021cb1bb67fd552e05d32dacb5ebd292053008834fd0defb5" => :yosemite
    sha256 "3d5b7662c7cf136f6ba87864f4ce67464228d2db2d31ffe8e470c7803d34bac4" => :mavericks
  end

  needs :cxx11

  option "with-opencl", "build with support for OpenCL actors"
  option "without-check", "skip unit tests (not recommended)"

  depends_on "cmake" => :build

  def install
    args = %W[./configure --prefix=#{prefix} --no-examples --build-static]
    args << "--no-opencl" if build.without? "opencl"

    system *args
    system "make"
    system "make", "test" if build.with? "check"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      int main() {
        scoped_actor self;
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
        self->await_all_other_actors_done();
        return 0;
      }
    EOS
    system *%W[#{ENV.cxx} -std=c++11 -stdlib=libc++ test.cpp -lcaf_core -o test]
    system "./test"
  end
end
