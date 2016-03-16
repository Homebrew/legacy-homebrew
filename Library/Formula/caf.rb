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
    sha256 "5af9861630a48af1f2ca080971ca054b49e002722ff8c427383c86a49ece0a4b" => :el_capitan
    sha256 "14594e9c59715838b582410ead87d7a1995338a02401865d02f8107805a050e3" => :yosemite
    sha256 "c3385b1d17da35c69b69a1abaae9e99de541533ee8a31bff227060309e049816" => :mavericks
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
