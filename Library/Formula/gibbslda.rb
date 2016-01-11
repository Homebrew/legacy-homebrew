class Gibbslda < Formula
  desc "Library wrapping imlib2's context API"
  homepage "http://gibbslda.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gibbslda/GibbsLDA%2B%2B/0.2/GibbsLDA%2B%2B-0.2.tar.gz"
  sha256 "4ca7b51bd2f098534f2fdf82c3f861f5d8bf92e29a6b7fbdc50c3c2baeb070ae"

  bottle do
    cellar :any
    sha256 "091c214c2589c2a2a0b0dcb90f45cf993ffeeb7d7260f505ef84f1fd773b326c" => :yosemite
    sha256 "bd4c35f5f73ae1aa5fdee00bd89c7b9c455c30061effe1660fbfbd203cb82cd3" => :mavericks
    sha256 "329fa8a93faa35c16e484a1198fcbc186b21e268e2ec91481c19787352bf1e41" => :mountain_lion
  end

  # Build fails without including stdlib - https://trac.macports.org/ticket/41915
  # https://sourceforge.net/p/gibbslda/bugs/4/
  patch :DATA

  def install
    system "make", "clean"
    system "make", "all"
    bin.install "src/lda"
    share.install "docs/GibbsLDA++Manual.pdf"
  end
end

__END__

diff --git a/src/utils.cpp b/src/utils.cpp
index e2f538b..1df5fb3 100644
--- a/src/utils.cpp
+++ b/src/utils.cpp
@@ -22,6 +22,7 @@
  */

 #include <stdio.h>
+#include <stdlib.h>
 #include <string>
 #include <map>
 #include "strtokenizer.h"
