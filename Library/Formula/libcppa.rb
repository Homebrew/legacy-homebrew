class Libcppa < Formula
  # TODO: since libcppa has been renamed to CAF, this formula should eventually
  # be renamed to 'caf.rb'.
  desc "Implementation of the Actor Model for C++"
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.13.2.tar.gz"
  sha256 "3ccf7e469740e750eef31f14b965b00f7b6e3a89b05086a088ca905b3b1a04e6"
  head "https://github.com/actor-framework/actor-framework.git",
    :branch => "develop"

  bottle do
    cellar :any
    sha256 "7534496109bd370daae9e9265ec4d380e6150c4f147ad5628e2b6f25620f71e2" => :yosemite
    sha256 "0524882f335b97e63b75867dfe2b22139c41fa6552a46c31d1f7a6079bc82483" => :mavericks
    sha256 "4d0143d27f761dcfae634babf7884a4f46f3953034c74451aa63aca9ad13dd8a" => :mountain_lion
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
