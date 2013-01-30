require 'formula'

class Libunistring < Formula
  homepage 'http://www.gnu.org/software/libunistring/'
  url 'http://ftpmirror.gnu.org/libunistring/libunistring-0.9.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/libunistring/libunistring-0.9.3.tar.gz'
  sha1 'e1ea13c24a30bc93932d19eb5ad0704a618506dd'

  def patches
    # Submitted upstream: https://savannah.gnu.org/bugs/?37751
    # I am not 100% sure if this is the right patch because libunistring
    # provides its own stdint.h (and stdint.mini.h) which wraps the system's
    # version of these files (in a complicated manner). This is fragile.
    DATA unless MacOS::CLT.installed?
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    # system "make check"  # Maintainers, you might want to do the check
    system "make install"
  end
end

__END__
diff --git a/lib/stdint.mini.h b/lib/stdint.mini.h
index d6f2cb0..3c0acc8 100644
--- a/lib/stdint.mini.h
+++ b/lib/stdint.mini.h
@@ -118,11 +118,6 @@ typedef unsigned int unistring_uint32_t;
 #define int32_t unistring_int32_t
 #define uint32_t unistring_uint32_t
 
-/* Avoid collision with Solaris 2.5.1 <pthread.h> etc.  */
-#define _UINT8_T
-#define _UINT32_T
-#define _UINT64_T
-
 
 #endif /* _UNISTRING_STDINT_H */
 #endif /* !defined _UNISTRING_STDINT_H && !defined _GL_JUST_INCLUDE_SYSTEM_STDINT_H */
