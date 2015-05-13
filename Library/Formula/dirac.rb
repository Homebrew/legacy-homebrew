require 'formula'

class Dirac < Formula
  homepage 'http://diracvideo.org/'
  url 'http://diracvideo.org/download/dirac-research/dirac-1.0.2.tar.gz'
  sha1 '895aaad832a54b754e58f77c87d38c0c37752b0b'

  fails_with :llvm do
    build 2334
  end

  # First two patches: the only two commits in the upstream repo not in 1.0.2

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/da8a53abcf057c58b498/raw/bde69c5f07d871542dcb24792110e29e6418d2a3/unititialized-memory.patch"
    sha256 "d5fcbb1b5c9f2f83935d71ebd312e98294121e579edbd7818e3865606da36e10"
  end

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/e729c459525d0d6e9e2d/raw/d9ff69c944b8bde006eef27650c0af36f51479f5/dirac-gcc-fixes.patch"
    sha256 "52c40f2c8aec9174eba2345e6ba9689ced1b8f865c7ced23e7f7ee5fdd6502c3"
  end

  # hack the configure script, which assumes any compiler that
  # starts with "cl" is a Microsoft compiler
  patch :DATA

  def install
    # BSD cp doesn't have '-d'
    inreplace 'doc/Makefile.in', 'cp -dR', 'cp -R'

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 41329b9..8f5ed19 100755
--- a/configure
+++ b/configure
@@ -15903,30 +15903,8 @@ ACLOCAL_AMFLAGS="-I m4 $ACLOCAL_AMFLAGS"
 use_msvc=no


-case "$CXX" in
-		cl*|CL*)
-		CXXFLAGS="-nologo -W1 -EHsc -DWIN32"
-		if test x"$enable_shared" = "xyes"; then
-		    LIBEXT=".dll";
-		    LIBFLAGS="-DLL -INCREMENTAL:NO"
-			CXXFLAGS="$CXXFLAGS -D_WINDLL"
-		else
-		    LIBEXT=".lib";
-		    LIBFLAGS="-lib"
-		fi
-		RANLIB="echo"
-		use_msvc=yes
-		;;
-	*)
-		;;
-esac
- if test x"$use_msvc" = "xyes"; then
-  USE_MSVC_TRUE=
-  USE_MSVC_FALSE='#'
-else
   USE_MSVC_TRUE='#'
   USE_MSVC_FALSE=
-fi



@@ -22678,7 +22656,8 @@ $debug ||
 if test -n "$CONFIG_FILES"; then


-ac_cr=''
+ac_cr='
+'
 ac_cs_awk_cr=`$AWK 'BEGIN { print "a\rb" }' </dev/null 2>/dev/null`
 if test "$ac_cs_awk_cr" = "a${ac_cr}b"; then
   ac_cs_awk_cr='\\r'
