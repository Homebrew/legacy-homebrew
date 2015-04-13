class Libcppa < Formula
  # TODO: since libcppa has been renamed to CAF, this formula should eventually
  # be renamed to 'caf.rb'.
  homepage "http://actor-framework.org/"
  # For this release (0.13.1) we do not use a github tag because we've added
  # mountain-lion compatibility fix discovered by brew-bot.
  version "0.13.1"
  url "https://github.com/actor-framework/actor-framework/archive/1c6f23eba0af2cbb545472c59ae3a6e6d14f7a2d.tar.gz"
  sha256 "6db0d93ccbb349d0cc93ce38ab312e4164959b95c325e4b02af074c0e5ccb024"
  head "https://github.com/actor-framework/actor-framework.git",
    :branch => "develop"

  bottle do
    cellar :any
    sha256 "2b0c07b1bd32cae582d99cfdebb3034056343e5893d29fdf30aab7af3d0954fb" => :yosemite
    sha256 "95421cb4101f8e2c3c7f0466ccd8efcf94e22e3e1d55c6e3fa83bfec500d91c2" => :mavericks
    sha256 "3bc6394e1b7c51ab09f2580c20f55cb9fa15b532d22a81b26cab249d88d9cc3b" => :mountain_lion
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
