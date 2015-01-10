class Libcppa < Formula
  # TODO: since libcppa has been renamed to CAF, this formula should eventually
  # be renamed to 'caf.rb'.
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.12.1.tar.gz"
  sha1 "a8267a2f5ab4f9124ab0b10279a6600c2867243b"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha1 "6842b3696ff8bdba97b133ad4e083f7bb20a7aa0" => :yosemite
    sha1 "d223bd5c8141dcfa9042baec831e5db8f071aadc" => :mavericks
    sha1 "8be3698123f1bd76c5a365f7387231085e72acd3" => :mountain_lion
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
