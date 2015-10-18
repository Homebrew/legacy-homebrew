class Cmigemo < Formula
  desc "Migemo is a tool that supports Japanese incremental search with Romaji"
  homepage "http://www.kaoriya.net/software/cmigemo"

  stable do
    url "https://cmigemo.googlecode.com/files/cmigemo-default-src-20110227.zip"
    sha256 "4aa759b2e055ef3c3fbeb9e92f7f0aacc1fd1f8602fdd2f122719793ee14414c"

    # Patch per discussion at: https://github.com/Homebrew/homebrew/pull/7005
    patch :DATA
  end

  head "https://github.com/koron/cmigemo.git"

  depends_on "nkf" => :build

  def install
    system "chmod +x ./configure"
    system "./configure", "--prefix=#{prefix}"
    system "make", "osx"
    system "make osx-dict"
    system "make", "-C", "dict", "utf-8" if build.stable?
    ENV.j1 # Install can fail on multi-core machines unless serialized
    system "make osx-install"
  end

  def caveats; <<-EOS.undent
    See also https://github.com/emacs-jp/migemo to use cmigemo with Emacs.
    You will have to save as migemo.el and put it in your load-path.
    EOS
  end
end

__END__
--- a/src/wordbuf.c	2011-08-15 02:57:05.000000000 +0900
+++ b/src/wordbuf.c	2011-08-15 02:57:17.000000000 +0900
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <limits.h>
 #include "wordbuf.h"

 #define WORDLEN_DEF 64
