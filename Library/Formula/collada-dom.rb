class ColladaDom < Formula
  desc "C++ library for loading and saving COLLADA data"
  homepage "https://www.khronos.org/collada/wiki/Portal:COLLADA_DOM"
  head "https://github.com/rdiankov/collada-dom.git"

  stable do
    url "https://downloads.sourceforge.net/project/collada-dom/Collada%20DOM/Collada%20DOM%202.4/collada-dom-2.4.0.tgz"
    sha256 "5ca2d12f744bdceff0066ed3067b3b23d6859581fb0d657f98ba4487d8fa3896"

    # Fix build of minizip: quoting arguments to cmake's add_definitions doesn't work the way they thought it did.
    # Fixed in 2.4.2; remove this when version gets bumped
    # https://github.com/rdiankov/collada-dom/issues/3
    patch :DATA
  end

  bottle do
    sha256 "98e726f47020580acc1a10be5366394fb137fc4729e3446e5e0130a69b2d38da" => :el_capitan
    sha256 "2be8761c8bd277b4cc720c900fff84cedbc2736a55329a9d107ded2712e97d75" => :yosemite
    sha256 "5ddb31dec3a705e99ca17ec2c6ef1bafb101eac16167d451c3e6eda2dc9c0761" => :mavericks
  end

  devel do
    url "https://github.com/rdiankov/collada-dom/archive/v2.4.4.tar.gz"
    sha256 "0dfa494827faa971310c871535b319cadbd0c2d6958ee11b303c61a55a5a437a"
  end

  depends_on "cmake" => :build
  depends_on "pcre"
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 72b6deb..0c7f7ce 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -100,7 +100,7 @@ endif()

 if( APPLE OR ${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
   # apple doesn't have 64bit versions of file opening functions, so add them
-  add_definitions("-Dfopen64=fopen -Dfseeko64=fseeko -Dfseek64=fseek -Dftell64=ftell -Dftello64=ftello")
+  add_definitions(-Dfopen64=fopen -Dfseeko64=fseeko -Dfseek64=fseek -Dftell64=ftell -Dftello64=ftello)
 endif()

 set(COLLADA_DOM_INCLUDE_INSTALL_DIR "include/collada-dom")
