require 'formula'

class Htmlcxx < Formula
  homepage 'http://htmlcxx.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/htmlcxx/htmlcxx/0.85/htmlcxx-0.85.tar.gz'
  sha1 'e56fef830db51041fd297d269d24379b2dccb928'

  # Don't try to use internal GCC headers; rely on standards-compliant header
  # Reported upstream: https://sourceforge.net/p/htmlcxx/bugs/18/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
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
