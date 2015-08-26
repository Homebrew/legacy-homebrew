class Rp < Formula
  desc "Tool to find ROP sequences in PE/Elf/Mach-O x86/x64 binaries"
  homepage "https://0vercl0k.github.io/rp/"
  head "https://github.com/0vercl0k/rp.git"
  url "https://github.com/0vercl0k/rp/archive/v1.tar.gz"
  version "1.0"
  sha256 "3bf69aee23421ffdc5c7fc3ce6c30eb7510640d384ce58f4a820bae02effebe3"

  depends_on :macos => :lion
  depends_on "cmake" => :build

  # In order to have the same binary name in 32 and 64 bits.
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", ".."
      system "make"
    end
    bin.install "bin/rp-osx"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 79d576b..34c2afa 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -36,12 +36,10 @@ set(RP_NAME "${RP_NAME}-${RP_PLAT}")

 if(CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT(optX86BUILD))
     set(FLAG_CXX "-m64")
-    set(RP_NAME "${RP_NAME}-x64")
     set(BEA_LIBRARY "BeaEngine.x64.${RP_PLAT}.${EXTENSION_LIBRARY}")
     set(ARGTABLE_LIBRARY "argtable2.x64.${RP_PLAT}.${EXTENSION_LIBRARY}")
 else()
     set(FLAG_CXX "-m32")
-    set(RP_NAME "${RP_NAME}-x86")
     set(BEA_LIBRARY "BeaEngine.x86.${RP_PLAT}.${EXTENSION_LIBRARY}")
     set(ARGTABLE_LIBRARY "argtable2.x86.${RP_PLAT}.${EXTENSION_LIBRARY}")
 endif(CMAKE_SIZEOF_VOID_P EQUAL 8 AND NOT(optX86BUILD))
