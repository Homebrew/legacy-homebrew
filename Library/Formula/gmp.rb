require 'formula'

class Gmp < Formula
  homepage 'http://gmplib.org/'
  url 'ftp://ftp.gmplib.org/pub/gmp/gmp-5.1.3.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/gmp/gmp-5.1.3.tar.bz2'
  sha1 'b35928e2927b272711fdfbf71b7cfd5f86a6b165'

  bottle do
    cellar :any
    revision 1
    sha1 '7a4392ecba5ef5077440358a6a1c86d9717e22f8' => :mountain_lion
    sha1 '8e7b9953d6c337dc6ee1ca97da5eede6b1c3d9be' => :lion
    sha1 '773bac38cc86dec84dc9b9abb246c56900cac7af' => :snow_leopard
  end

  option '32-bit'

  # Patches gmp.h to remove the __need_size_t define, which
  # was preventing libc++ builds from getting the ptrdiff_t type
  # Applied upstream in http://gmplib.org:8000/gmp/raw-rev/6cd3658f5621
  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}", "--enable-cxx"]

    if build.build_32_bit?
      ENV.m32
      ENV.append 'ABI', '32'
      # https://github.com/mxcl/homebrew/issues/20693
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
