class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.15.2-beta2/ldc-0.15.2-beta2-src.tar.gz"
  version "0.15.2-beta2"
  sha256 "b421acbca0cdeef42c5af2bd53060253822dea6d78d216f973ee5e2b362723e2"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "42429da7c6b69babb33d17797492179faf584cee6a55980f5beba8c79d951c5a" => :yosemite
    sha256 "0b9aaf9f9f5b8dc05a4a0989ce1d54bd81fe857e36d84d54dee0ba3cad008c09" => :mavericks
    sha256 "8ea1ad6cbd93ca1b909fdce9ff136fe56ada447cd535840f2684088dcab0fea2" => :mountain_lion
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
