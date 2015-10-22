class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.16.0/ldc-0.16.0-src.tar.gz"
  sha256 "0a697936d7f8fe123a80d63bb76e50958d40d3ca31ccb6d558107ed67b15c74d"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    revision 1
    sha256 "fa6b927c78ab8c9e3654681896aa52dfb9429dc4c4eb159cc36104a8c195d440" => :el_capitan
    sha256 "d881f7491f5e27659f4e6f1b12c363b99d02e73073b8003d6e648bebc1a53204" => :yosemite
    sha256 "f5f1741065b18bdcd4051f29f4df5a93b85cee1e8c5e8a3598477c10d123be8e" => :mavericks
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
