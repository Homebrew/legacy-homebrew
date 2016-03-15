class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "http://actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.14.5.tar.gz"
  sha256 "afc4bc928ecd7d017768e5c85b7300196aa5b70ef11d97e11b21a1ae28ce9d3f"
  head "https://github.com/actor-framework/actor-framework.git",
    :branch => "develop"

  bottle do
    cellar :any
    sha256 "c161ba6878e220bd41ba3b387e04c9af5148a11ca76fda4b12cf90c3ad7f285c" => :el_capitan
    sha256 "058410d9287e31c1c5bc956749dd88b3756429fddcae9626fa3cf4fb0a482a6d" => :yosemite
    sha256 "cce3011d963e53ac1fe86e0155d76d6396b676066ddbf0c4aa7f9ea9917abd08" => :mavericks
  end

  needs :cxx11

  option "with-opencl", "build with support for OpenCL actors"
  option "without-test", "skip unit tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "cmake" => :build

  def install
    args = %W[--prefix=#{prefix} --no-examples --build-static]
    args << "--no-opencl" if build.without? "opencl"

    system "./configure", *args
    system "make"
    system "make", "test" if build.with? "test"
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
    system ENV.cxx, "-std=c++11", "-stdlib=libc++", "test.cpp",
      "-lcaf_core", "-o", "test"
    system "./test"
  end
end
