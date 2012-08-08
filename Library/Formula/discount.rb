require 'formula'

class Discount < Formula
  homepage 'http://www.pell.portland.or.us/~orc/Code/discount/'
  url 'https://github.com/Orc/discount/tarball/v2.1.3'
  sha1 '9d2dc33a1f80e7dd56f2c7ee1aec0a3e6e60302f'

  # Work around clang-incompatible test
  # We know we have strcasecmp and strncasecmp, so just
  # skip the test. Repoted upstream in
  # https://github.com/Orc/discount/issues/55
  def patches; DATA; end

  def install
    system "./configure.sh", "--prefix=#{prefix}",
                             "--mandir=#{man}",
                             "--with-dl=Both",
                             "--enable-all-features"
    bin.mkpath
    lib.mkpath
    include.mkpath
    system "make install.everything"
  end
end

__END__
diff --git a/configure.sh b/configure.sh
index 43ef971..821832b 100755
--- a/configure.sh
+++ b/configure.sh
@@ -102,22 +102,6 @@ else
     AC_DEFINE 'COINTOSS()' '1'
 fi
 
-if AC_CHECK_FUNCS strcasecmp; then
-    :
-elif AC_CHECK_FUNCS stricmp; then
-    AC_DEFINE strcasecmp stricmp
-else
-    AC_FAIL "$TARGET requires either strcasecmp() or stricmp()"
-fi
-
-if AC_CHECK_FUNCS strncasecmp; then
-    :
-elif AC_CHECK_FUNCS strnicmp; then
-    AC_DEFINE strncasecmp strnicmp
-else
-    AC_FAIL "$TARGET requires either strncasecmp() or strnicmp()"
-fi
-
 if AC_CHECK_FUNCS fchdir || AC_CHECK_FUNCS getcwd ; then
     AC_SUB 'THEME' ''
 else
