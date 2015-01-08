class Libcppa < Formula
  # TODO: since libcppa has been renamed to CAF, this formula should eventually
  # be renamed to 'caf.rb'.
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.12.0.tar.gz"
  sha1 "cb4e2c9a859d2d3095014237d4cdad63c1853c8c"
  head "https://github.com/actor-framework/actor-framework.git"

  bottle do
    cellar :any
    sha1 "b0e9bef1983d561763e21539c9b9196d75e5a935" => :yosemite
    sha1 "ed71bb57236d2aecf4e19e5044ca3af22969b5c5" => :mavericks
    sha1 "8224fe20d5d4bd184a9b6c15ddd6143740ea23ca" => :mountain_lion
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
