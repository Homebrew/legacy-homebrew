class Mstch < Formula
  desc "Complete implementation of {{mustache}} templates using modern C++"
  homepage "https://github.com/no1msd/mstch"
  url "https://github.com/no1msd/mstch/archive/1.0.1.tar.gz"
  sha256 "0f8ce1c47ff6b52c6f347b443447651b549366a21d086927fe0b27e14da5620e"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5a6f5c4de5a6e1c99b359db64e6ee89244cd1ed6b38872e4f257db00bdaa792" => :el_capitan
    sha256 "9905c1ff49882abf0a5dca1e609afc10a8e02f4cab010d8bb33d5347388f52b7" => :yosemite
    sha256 "e55ffb2f8c98dab7fd74fbf58bd71651f945d8d3a0bb6f12eed397386e872860" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    (lib/"pkgconfig/mstch.pc").write pc_file
  end

  def pc_file; <<-EOS.undent
    prefix=#{HOMEBREW_PREFIX}
    exec_prefix=${prefix}
    libdir=${exec_prefix}/lib
    includedir=${exec_prefix}/include

    Name: mstch
    Description: Complete implementation of {{mustache}} templates using modern C++
    Version: 1.0.1
    Libs: -L${libdir} -lmstch
    Cflags: -I${includedir}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <mstch/mstch.hpp>
      #include <cassert>
      #include <string>
      int main() {
        std::string view("Hello, world");
        mstch::map context;

        assert(mstch::render(view, context) == "Hello, world");
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lmstch", "-std=c++11", "-o", "test"
    system "./test"
  end
end
