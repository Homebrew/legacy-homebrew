class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v0.16.1/ldc-0.16.1-src.tar.gz"
  sha256 "e66cea99f0b1406bbd265ad5fe6aa1412bae31ac86d8a678eb6751f304b6f95b"

  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  bottle do
    revision 1
    sha256 "a6e331a7a27d1e2156584db13e51630b18c75e9697da5dcefcb397ed2fac2900" => :el_capitan
    sha256 "57b850193b0dd8893a18415c12278016bacea30a83e6ecd7f1bbf0bfc6d96635" => :yosemite
    sha256 "1ceba457bb23a61ade8a1c573c4d96ca024e3e051e1b8bbff2eea1d0089ad307" => :mavericks
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v0.17.0-alpha1/ldc-0.17.0-alpha1-src.tar.gz"
    sha256 "68b13ece2d1aae6876cce3e143949966282a287169472b84c5bce5c119340532"
    version "0.17.0-a1"
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
