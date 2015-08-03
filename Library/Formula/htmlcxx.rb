class Htmlcxx < Formula
  desc "Non-validating CSS1 and HTML parser for C++"
  homepage "http://htmlcxx.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/htmlcxx/htmlcxx/0.85/htmlcxx-0.85.tar.gz"
  sha256 "ab02a0c4addc82f82d564f7d163fe0cc726179d9045381c288f5b8295996bae5"

  # Don't try to use internal GCC headers; rely on standards-compliant header
  # Reported upstream: https://sourceforge.net/p/htmlcxx/bugs/18/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/html/ci_string.h b/html/ci_string.h
index 61ed462..e461469 100644
--- a/html/ci_string.h
+++ b/html/ci_string.h
@@ -4,16 +4,7 @@
 #include <cctype>
 #include <string>
 
-#if __GNUC__ >= 3
-#include <bits/char_traits.h>
 struct ci_char_traits : public std::char_traits<char>
-#elif defined(__GNUC__)
-#include <std/straits.h>
-struct ci_char_traits : public std::string_char_traits<char>
-#else 
-//Hope string already include it
-struct ci_char_traits : public std::char_traits<char>
-#endif
 
 // just inherit all the other functions
 //  that we don't need to override
