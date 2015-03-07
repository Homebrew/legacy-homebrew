require "formula"

class Ldc < Formula
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.15.1/ldc-0.15.1-src.tar.gz"
  sha1 "06db0c07d73bf714e6fc7a4aca4c44123e4a585a"

  bottle do
    sha1 "bc329c6a0f9f52d634c99877a6c020436307b941" => :yosemite
    sha1 "86d65479ffc178437ed3f0dd0ea05549eede13ed" => :mavericks
    sha1 "7a89443907b3d2af67d46f273c0949f0a587c456" => :mountain_lion
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

    system "#{bin}/ldc2", 'test.d'
    system "./test"
    system "#{bin}/ldmd2", 'test.d'
    system "./test"
  end
end
