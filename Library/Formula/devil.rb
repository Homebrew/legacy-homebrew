class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  url "https://downloads.sourceforge.net/project/openil/DevIL/1.7.8/DevIL-1.7.8.tar.gz"
  sha256 "682ffa3fc894686156337b8ce473c954bf3f4fb0f3ecac159c73db632d28a8fd"
  revision 1

  bottle :disable, "Can't generate bottles until builds with either Clang or GCC-5"

  option :universal

  depends_on "libpng"
  depends_on "jpeg"

  # see https://sourceforge.net/p/openil/bugs/204/
  # also, even with -std=gnu99 removed from the configure script,
  # devil fails to build with clang++ while compiling il_exr.cpp
  fails_with :clang do
    cause "invalid -std=gnu99 flag while building C++"
  end

  # ./../src-IL/include/il_internal.h:230:54: error: expected ',' or '...' before 'FileName'
  # https://github.com/Homebrew/homebrew/issues/40442
  fails_with :gcc => "5"

  # fix compilation issue for iluc.c
  patch :DATA

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-ILU",
                          "--enable-ILUT"
    system "make", "install"
  end
end

__END__
--- a/src-ILU/ilur/ilur.c   2009-03-08 08:10:12.000000000 +0100
+++ b/src-ILU/ilur/ilur.c  2010-09-26 20:01:45.000000000 +0200
@@ -1,6 +1,7 @@
 #include <string.h>
 #include <stdio.h>
-#include <malloc.h>
+#include <stdlib.h>
+#include "sys/malloc.h"

 #include <IL/il.h>
 #include <IL/ilu.h>

