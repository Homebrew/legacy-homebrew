require "formula"

class MecabKoDic < Formula
  homepage "https://bitbucket.org/bibreen/mecab-ko-dic"
  url "https://bitbucket.org/bibreen/mecab-ko-dic/downloads/mecab-ko-dic-1.4.3-20131115.tar.gz"
  sha1 "8a6165f564f8285942dbd838f12c52e7dfa29357"

  depends_on :autoconf
  depends_on :automake
  depends_on 'mecab-ko'

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-dicdir=#{prefix}"
    system "make install"
  end
end


__END__
--- a/configure
+++ b/configure
@@ -1705,9 +1705,6 @@ ac_compile='$CC -c $CFLAGS $CPPFLAGS con
 ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&5'
 ac_compiler_gnu=$ac_cv_c_compiler_gnu

-
-am__api_version='1.11'
-
 ac_aux_dir=
 for ac_dir in "$srcdir" "$srcdir/.." "$srcdir/../.."; do
   if test -f "$ac_dir/install-sh"; then
@@ -2187,13 +2184,13 @@ _ACEOF

 # Some tools Automake needs.

-ACLOCAL=${ACLOCAL-"${am_missing_run}aclocal-${am__api_version}"}
+ACLOCAL=${ACLOCAL-"${am_missing_run}aclocal"}


 AUTOCONF=${AUTOCONF-"${am_missing_run}autoconf"}


-AUTOMAKE=${AUTOMAKE-"${am_missing_run}automake-${am__api_version}"}
+AUTOMAKE=${AUTOMAKE-"${am_missing_run}automake"}


 AUTOHEADER=${AUTOHEADER-"${am_missing_run}autoheader"
