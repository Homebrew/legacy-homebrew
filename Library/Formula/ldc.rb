class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "http://wiki.dlang.org/LDC"
  head "https://github.com/ldc-developers/ldc.git", :shallow => false

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v0.16.1/ldc-0.16.1-src.tar.gz"
    sha256 "e66cea99f0b1406bbd265ad5fe6aa1412bae31ac86d8a678eb6751f304b6f95b"

    # Fixes build errors in release mode, fixed in 0.17.0-beta2
    patch :DATA
  end

  bottle do
    revision 2
    sha256 "628ca57025ff91d4bfb27f80831326baf96beed0fb491b8d3e309857f77b22b5" => :el_capitan
    sha256 "b0cb0e8439f449c9962e2b697c247d4cff12bc0c7008108612188adc57bf2015" => :yosemite
    sha256 "29ddf8baaf36667e624e31c88b5517d466446fc10d6d669f3923000b1355d38f" => :mavericks
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
