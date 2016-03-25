class Dirac < Formula
  desc "General-purpose video codec aimed at a range of resolutions"
  homepage "http://diracvideo.org/"
  url "https://downloads.sourceforge.net/project/dirac/dirac-codec/Dirac-1.0.2/dirac-1.0.2.tar.gz"
  mirror "https://launchpad.net/ubuntu/+archive/primary/+files/dirac_1.0.2.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dirac/dirac_1.0.2.orig.tar.gz"
  sha256 "816b16f18d235ff8ccd40d95fc5b4fad61ae47583e86607932929d70bf1f00fd"

  bottle do
    cellar :any
    revision 1
    sha256 "8f4414614755f863d3ba0f43d6415684fbc00976ae24c7e45c88fe736be918d2" => :el_capitan
    sha256 "1d3049d9dcdbd0116c65c54582601b20cdd17c8b89cf80e74efc79f71b641ca4" => :yosemite
    sha256 "e7c407545085631c27c77f2d15abe84b3cc0a3645cf5e538aa15f0aacfe6de50" => :mavericks
  end

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

  # HACK: the configure script, which assumes any compiler that
  # starts with "cl" is a Microsoft compiler
  patch :DATA

  def install
    # BSD cp doesn't have '-d'
    inreplace "doc/Makefile.in", "cp -dR", "cp -R"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
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
