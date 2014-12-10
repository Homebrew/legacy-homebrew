require "formula"

class Ldc < Formula
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.14.0/ldc-0.14.0-src.tar.gz"
  sha1 "843c9fb374bb900560f9548d5c4646788f967103"

  bottle do
    sha1 "824272b3e29e1a5cdf03669099690f5c10021396" => :mavericks
    sha1 "fd8121391a3528604cfb65da4dbf16ca499b8f76" => :mountain_lion
    sha1 "fc18d767e69eca7d9a7a5456a5524c7ce1cb3d29" => :lion
  end

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
