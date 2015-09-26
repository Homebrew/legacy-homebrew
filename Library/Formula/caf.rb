class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.14.1.tar.gz"
  sha256 "8940474ae0c3700e503d092f124489a13667098b63b8e94a09e110541d827985"
  head "https://github.com/actor-framework/actor-framework.git",
    :branch => "develop"

  bottle do
    cellar :any
    sha256 "c1c051d79566b1a260296ca8b10d1c44d48e4592e70a2d74483684f86102fbcc" => :yosemite
    sha256 "b27513e9fb42b65f94e2f732a75f9eb4cdfe7e552fa0690b03b2f03593bb9c87" => :mavericks
    sha256 "8939cef5647b3241311801cdf4396a9342a55d6c6e2303e74b013d55a9583ef7" => :mountain_lion
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
