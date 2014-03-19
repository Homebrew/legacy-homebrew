require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp/gmp-5.1.3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.1.3.tar.bz2'
  sha1 'b35928e2927b272711fdfbf71b7cfd5f86a6b165'

  bottle do
    cellar :any
    revision 2
    sha1 '8390518974834c6a9e959e3a9d6e5eba91152eec' => :mavericks
    sha1 'b042ffe0c394dafab04f23ce03dc2cb691dc2a87' => :mountain_lion
    sha1 'a767aafc398054b6eb413b7dd70c7c9721d84734' => :lion
  end

  option '32-bit'
  option :cxx11

  # Patches gmp.h to remove the __need_size_t define, which
  # was preventing libc++ builds from getting the ptrdiff_t type
  # Applied upstream in http://gmplib.org:8000/gmp/raw-rev/6cd3658f5621
  patch :DATA

  def install
    ENV.cxx11 if build.cxx11?
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      ENV.append 'ABI', '32'
      # https://github.com/Homebrew/homebrew/issues/20693
      args << "--disable-assembly"
    elsif build.bottle?
      args << "--disable-assembly"
    end

    system "./configure", *args
    system "make"
    system "make check"
    ENV.deparallelize
    system "make install"
  end
end

__END__
diff --git a/gmp-h.in b/gmp-h.in
index 7deb67a..240d663 100644
--- a/gmp-h.in
+++ b/gmp-h.in
@@ -46,13 +46,11 @@ along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.  */
 #ifndef __GNU_MP__
 #define __GNU_MP__ 5
 
-#define __need_size_t  /* tell gcc stddef.h we only want size_t */
 #if defined (__cplusplus)
 #include <cstddef>     /* for size_t */
 #else
 #include <stddef.h>    /* for size_t */
 #endif
-#undef __need_size_t
 
 /* Instantiated by configure. */
 #if ! defined (__GMP_WITHIN_CONFIGURE)
