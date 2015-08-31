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
    sha256 "b3f1eda0f3a8c94c01cb5b666ec48f967122261624de369b01ca521a4684b785" => :yosemite
    sha256 "4166393da6e1271d773cdc12da96ef73cbfd856025472cb3ba6e921846f340e3" => :mavericks
    sha256 "0aeed3e05e4961d7a24dda83370ceb2b7abf758b0abc0a0eb9f54e465151d7c6" => :mountain_lion
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
