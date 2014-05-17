require 'formula'

class Tinyscheme < Formula
  homepage 'http://tinyscheme.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.40/tinyscheme-1.40.tar.gz'
  sha1 'e03f7ac41f0517bb35eced2772c79eb9db42ea82'

  bottle do
    sha1 "4946723ab6e7e3689ca087574a3ae7078d50ff84" => :mavericks
    sha1 "7c272214c941b749a3e9b57744fbd33564151b78" => :mountain_lion
    sha1 "f2f6def9dc2ef11876dd1e307634ac454302ed11" => :lion
  end

  conflicts_with 'mit-scheme', :because => 'both install a `scheme` binary'

  # Modify compile flags for Mac OS X per instructions
  patch :DATA

  def install
    system 'make', "INITDEST=#{share}"
    lib.install('libtinyscheme.dylib')
    share.install('init.scm')
    bin.install('scheme')
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
