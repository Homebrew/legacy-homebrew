require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Elementary < Formula
  homepage 'http://docs.enlightenment.org/auto/elementary/'
  url 'http://download.enlightenment.org/releases/elementary-1.7.5.tar.bz2'
  sha1 'fa51b18c262efc944f3f5824b0e432e26667831d'

  head 'http://svn.enlightenment.org/svn/e/trunk/elementary/'

  if ARGV.build_head?
    depends_on :libtool
  end

  depends_on 'automake'
  depends_on 'eina'
  depends_on 'ecore'
  depends_on 'evas'
  depends_on 'emotion'
  depends_on 'edje'

  depends_on 'pkg-config' => :build

  def patches
    #repairs 'checkenv' detection
    DATA
  end

  def install
    # ENV.j1  # if your formula's build system can't parallelize

    system "./autogen.sh", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test elementary`.
    system "false"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 668fcda..f2b8d86 100644
--- a/configure.ac
+++ b/configure.ac
@@ -201,6 +201,7 @@ if test "x$want_quicklaunch" != "xno"; then
         have_fork="yes"
         AC_DEFINE(HAVE_FORK)
    ])
+   AC_CHECK_FUNCS(clearenv)
 fi
 AM_CONDITIONAL([BUILD_QUICKLAUNCH], [test "x$have_fork" = "xyes" && test "x$have_dlopen" = "xyes"])
 
@@ -732,14 +733,6 @@ extern char **environ;
   AC_DEFINE(HAVE_ENVIRON, 1, [extern environ exists])
 ])
 
-AC_TRY_COMPILE([
-#include <stdlib.h>
-], [
-clearenv();
-], [
-  AC_DEFINE(HAVE_CLEARENV, 1, [extern environ exists])
-])
-
 AC_OUTPUT([
 Makefile
 elementary.spec

diff --git a/src/bin/Makefile.am b/src/bin/Makefile.am
index 6f58a5f..c26a352 100644
--- a/src/bin/Makefile.am
+++ b/src/bin/Makefile.am
@@ -158,6 +158,7 @@ elementary_quicklaunch_LDADD = $(top_builddir)/src/lib/libelementary.la \
 	@ELEMENTARY_EFREET_LIBS@ \
 	@ELEMENTARY_EMAP_LIBS@ \
 	@ELEMENTARY_LIBS@ \
+	@LTLIBINTL@ \
 	@my_libs@
 elementary_quicklaunch_LDFLAGS =
