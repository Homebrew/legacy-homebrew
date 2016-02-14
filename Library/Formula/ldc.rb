class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.17.0/ldc-0.17.0-src.tar.gz"
  sha256 "6c80086174ca87281413d7510641caf99dc630e6cf228a619d0d989bbf53bdd2"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "61f7c63543741ef4cbadbd5ca293c94e2fcd7432dcf80bfe9d86bf4af0681525" => :el_capitan
    sha256 "40b0e843810f13dd9e712c4f2720db1ac5cfdd546e23f394cad9e266a5552829" => :yosemite
    sha256 "abe6b024e237061510b6b9f68508177803f162849a8e950cb3a8832da3ac8593" => :mavericks
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "libconfig"

  def install
    ENV.cxx11
    mkdir "build"
    cd "build" do
      system "cmake", "..", "-DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc", *std_cmake_args
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
