class Tinyscheme < Formula
  desc "Very small Scheme implementation"
  homepage "http://tinyscheme.sourceforge.net"
  url "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.40/tinyscheme-1.40.tar.gz"
  sha256 "c594c84633b1dcfe832e0416cbc9f889b6bae352845e14503883119a941a12fc"

  bottle do
    sha256 "07b1e56bfb5981a2d04165ac7bfca7cc25552102a6d71c8f60274fdc7085e318" => :mavericks
    sha256 "5b4009bbe6986a1b9cf1c606712a4fcbf697afedcb2ca58f88b170326af85390" => :mountain_lion
    sha256 "82cbe54a888e53b280dc1ca8f33470eecee06d74be2d1d7df949385198f75238" => :lion
  end

  # Modify compile flags for Mac OS X per instructions
  patch :DATA

  def install
    system "make", "INITDEST=#{share}"
    lib.install("libtinyscheme.dylib")
    share.install("init.scm")
    bin.install("scheme")
  end
end

__END__
--- a/makefile  2011-01-16 20:51:17.000000000 +1300
+++ b/makefile  2012-04-08 22:38:11.000000000 +1200
@@ -21,7 +21,7 @@
 CC = gcc -fpic
 DEBUG=-g -Wall -Wno-char-subscripts -O
 Osuf=o
-SOsuf=so
+SOsuf=dylib
 LIBsuf=a
 EXE_EXT=
 LIBPREFIX=lib
@@ -34,7 +34,6 @@
 LDFLAGS = -shared
 DEBUG=-g -Wno-char-subscripts -O
 SYS_LIBS= -ldl
-PLATFORM_FEATURES= -DSUN_DL=1

 # Cygwin
 #PLATFORM_FEATURES = -DUSE_STRLWR=0
@@ -50,8 +49,7 @@
 #LIBPREFIX = lib
 #OUT = -o $@

-FEATURES = $(PLATFORM_FEATURES) -DUSE_DL=1 -DUSE_MATH=0 -DUSE_ASCII_NAMES=0
-
+FEATURES = $(PLATFORM_FEATURES) -DUSE_DL=1 -DUSE_MATH=1 -DUSE_ASCII_NAMES=0 -DOSX -DInitFile="\"$(INITDEST)/init.scm"\"
 OBJS = scheme.$(Osuf) dynload.$(Osuf)

 LIBTARGET = $(LIBPREFIX)tinyscheme.$(SOsuf)
