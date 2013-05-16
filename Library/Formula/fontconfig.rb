require 'formula'

class Fontconfig < Formula
  homepage 'http://fontconfig.org/'
  url 'http://fontconfig.org/release/fontconfig-2.10.92.tar.bz2'
  sha1 '5897402b2d05b7dca2843106b6a0e86c39ad0a4c'

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on :freetype
  depends_on 'pkg-config' => :build

  def patches
    [
      # Patch adapted from Macports patch for 2.9.0 defines sizeof based on __LP64__
      # Fixes universal builds but seems groovy enough to apply in all cases.
      # https://trac.macports.org/browser/trunk/dports/graphics/fontconfig/files/patch-check-arch-at-runtime.diff
      DATA,

      # Patch copied over from Fedora to correct a bug with in memory fonts
      # that breaks Firefox, libass and a lot of other sofware
      # See https://github.com/mxcl/homebrew/issues/19312 for details.
      # NOTE: This will probably be fixed in next fontconfig.
      'http://pkgs.fedoraproject.org/cgit/fontconfig.git/plain/fontconfig-fix-woff.patch?id=e669d0170be4492cd966114122ad5281ec2276de'
    ]
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--with-add-fonts=/Library/Fonts,~/Library/Fonts",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/src/fcarch.h	2012-07-23 19:01:32.000000000 -0700
+++ b/src/fcarch.h	2012-10-20 10:29:15.000000000 -0700
@@ -46,6 +46,19 @@
  * be64		1234		8		8
  */

+#ifdef __APPLE__
+# include <machine/endian.h>
+# undef SIZEOF_VOID_P
+# undef ALIGNOF_DOUBLE
+# ifdef __LP64__
+#  define SIZEOF_VOID_P 8
+#  define ALIGNOF_DOUBLE 8
+# else
+#  define SIZEOF_VOID_P 4
+#  define ALIGNOF_DOUBLE 4
+# endif
+#endif
+
 #if defined(__DARWIN_BYTE_ORDER) && __DARWIN_BYTE_ORDER == __DARWIN_LITTLE_ENDIAN
 # define FC_ARCH_ENDIAN "le"
 #elif defined(__DARWIN_BYTE_ORDER) && __DARWIN_BYTE_ORDER == __DARWIN_BIG_ENDIAN
