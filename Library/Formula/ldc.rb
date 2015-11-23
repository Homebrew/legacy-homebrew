class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.16.1/ldc-0.16.1-src.tar.gz"
  sha256 "e66cea99f0b1406bbd265ad5fe6aa1412bae31ac86d8a678eb6751f304b6f95b"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "d358950e5bc80c8c51303b033f20f68496c65c15cdb74a06c8ad7b386ca9907b" => :el_capitan
    sha256 "0ed16e8ad04729ce88eef3ee436fbe14acf99941fffbcffa40b94724c105176a" => :yosemite
    sha256 "0d1f8e211e525e8eb106aa1ec6553240d8813e82dfec8bca0adc3cda590fc9a8" => :mavericks
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libconfig"

  def install
    ENV.cxx11
    mkdir "build"
    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;

      void main() {
        writeln("Hello, world!");
      }
    EOS

    system "#{bin}/ldc2", "test.d"
    system "./test"
    system "#{bin}/ldmd2", "test.d"
    system "./test"
  end
end
