require "formula"

class Ldc < Formula
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.14.0/ldc-0.14.0-src.tar.gz"
  sha1 "843c9fb374bb900560f9548d5c4646788f967103"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libconfig"

  def install
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
