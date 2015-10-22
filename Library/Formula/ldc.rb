class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.16.0/ldc-0.16.0-src.tar.gz"
  sha256 "0a697936d7f8fe123a80d63bb76e50958d40d3ca31ccb6d558107ed67b15c74d"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "785ffe1214f8b4eaf48d1eae2dd32322c31e9a8d88578c686d406e7aa686b49f" => :el_capitan
    sha256 "06bfbcc223532a3d47705c8e1e729fa74c6ae6ad8585fa92ad6012b80311e203" => :yosemite
    sha256 "6403ea94c78c34e30b40007ff27898569627fc9d837b23717af2966dad3b88aa" => :mavericks
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
