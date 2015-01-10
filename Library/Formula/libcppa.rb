class Libcppa < Formula
  # TODO: since libcppa has been renamed to CAF, this formula should eventually
  # be renamed to 'caf.rb'.
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.12.1.tar.gz"
  sha1 "a8267a2f5ab4f9124ab0b10279a6600c2867243b"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha1 "f25112267d00fb02519e4f797232ec940db41663" => :yosemite
    sha1 "94bbdc9254f635a04bd71e3279404eb3d1cf3e53" => :mavericks
    sha1 "093d8296dac70db13c09aa0845bb31625bd76929" => :mountain_lion
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
