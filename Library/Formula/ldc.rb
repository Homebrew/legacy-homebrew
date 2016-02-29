class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.17.0/ldc-0.17.0-src.tar.gz"
  sha256 "6c80086174ca87281413d7510641caf99dc630e6cf228a619d0d989bbf53bdd2"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    sha256 "c2ff6360645d4deb2ec135b262d257e85228df95e7765adb9e3a625b76250923" => :el_capitan
    sha256 "551a58a74107f93620af10964ef3128642ae4575ad2be31c618935ced420cd47" => :yosemite
    sha256 "6d9d60e0a1711a12e03729f273459363873286ce77977801cfbbfc517fc7af1a" => :mavericks
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
