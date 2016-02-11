class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false
  revision 1

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v0.16.1/ldc-0.16.1-src.tar.gz"
    sha256 "e66cea99f0b1406bbd265ad5fe6aa1412bae31ac86d8a678eb6751f304b6f95b"

    # Fixes build errors in release mode, fixed in 0.17.0-beta2
    patch :DATA
  end

  bottle do
    sha256 "61f7c63543741ef4cbadbd5ca293c94e2fcd7432dcf80bfe9d86bf4af0681525" => :el_capitan
    sha256 "40b0e843810f13dd9e712c4f2720db1ac5cfdd546e23f394cad9e266a5552829" => :yosemite
    sha256 "abe6b024e237061510b6b9f68508177803f162849a8e950cb3a8832da3ac8593" => :mavericks
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v0.17.0-beta2/ldc-0.17.0-beta2-src.tar.gz"
    sha256 "6d00b29928556f1220332a230dd743169c30f18333724254ac3f58244d98a6d7"
    version "0.17.0-beta2"
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
__END__
diff --git a/cmake/Modules/FindLLVM.cmake b/cmake/Modules/FindLLVM.cmake
index a1a5118..fe9902e 100644
--- a/cmake/Modules/FindLLVM.cmake
+++ b/cmake/Modules/FindLLVM.cmake
@@ -151,6 +151,7 @@ else()
     llvm_set(HOST_TARGET host-target)
     llvm_set(INCLUDE_DIRS includedir true)
     llvm_set(ROOT_DIR prefix true)
+    llvm_set(ENABLE_ASSERTIONS assertion-mode)

     if(${LLVM_VERSION_STRING} MATCHES "^3\\.[0-2][\\.0-9A-Za-z]*")
         # Versions below 3.3 do not support components objcarcopts, option
