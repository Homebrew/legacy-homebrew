class Libcppa < Formula
  # TODO: since libcppa has been renamed to CAF, this formula should eventually
  # be renamed to 'caf.rb'.
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.12.2.tar.gz"
  sha1 "003655f524a727fa8ccb5b41b6d997b299f5b496"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha1 "d147228e33f56e7d8d583d049c7983e6dea4c418" => :yosemite
    sha1 "2b2916dc07ca27f5b98d8d78d363c04fee860abf" => :mavericks
    sha1 "88e3a062a1ed03d4b8297daf3670f8f834ee60dd" => :mountain_lion
  end

  depends_on "cmake" => :build

  needs :cxx11

  option "with-opencl", "build with support for OpenCL actors"
  option "without-check", "skip unit tests (not recommended)"

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
