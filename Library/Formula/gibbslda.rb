class Gibbslda < Formula
  desc "Library wrapping imlib2's context API"
  homepage "http://gibbslda.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gibbslda/GibbsLDA%2B%2B/0.2/GibbsLDA%2B%2B-0.2.tar.gz"
  sha256 "4ca7b51bd2f098534f2fdf82c3f861f5d8bf92e29a6b7fbdc50c3c2baeb070ae"

  bottle do
    cellar :any
    sha1 "0a0861b3c2fd9037a8ec71f43a09115dceaed4a8" => :yosemite
    sha1 "65dd821a8ce2c7f24001a56218b0c00cdf1d9051" => :mavericks
    sha1 "7ecc74e2069e864ac26614209a7236215ab4faa0" => :mountain_lion
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
