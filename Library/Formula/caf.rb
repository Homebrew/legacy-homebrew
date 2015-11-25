class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.14.4.tar.gz"
  sha256 "7e77b1edc708ac66be3ab2ba29506681458422e59a2e1b3cd801152ba345fb00"
  head "https://github.com/actor-framework/actor-framework.git",
    :branch => "develop"

  bottle do
    cellar :any
    sha256 "54374543c3c48e903c0a710d072879be7b35f27de67d3d8cedfb6d0cae829e22" => :el_capitan
    sha256 "365781a7d8d53435a3872b7f20dede4610d5e7dc8e0730e285cde44b3aab3937" => :yosemite
    sha256 "4d43b93532b105c6641cd9fa6045ca611d966a6e96b0e7735c700ada4d0650b5" => :mavericks
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
