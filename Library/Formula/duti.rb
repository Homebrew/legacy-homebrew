require 'formula'

class Duti < Formula
  homepage 'http://duti.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/duti/duti/duti-1.5.0/duti-1.5.0.tar.gz'
  sha1 '105553ef2a5e63adc348f8247f727b5671d884ce'

  depends_on 'autoconf' => :build

  def patches
    # Fixes compilation on OS X 10.7 and 10.8
    # Patch taken from here: http://duti.git.sourceforge.net/git/gitweb.cgi?p=duti/duti;a=commitdiff;h=a12d3f73078554e91892f48f97ac4137a331e144
    DATA
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/duti", "-x", "txt"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index a9bc26f..43698e2 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -15,7 +15,7 @@ DUTI_BUILD_DATE=@build_date@
 CC=		@CC@
 FRAMEWORKS=	-framework ApplicationServices -framework CoreFoundation
 OPTOPTS=	-isysroot @macosx_sdk@ \
-			-arch i386 -arch ppc \
+			@macosx_arches@ \
 			-mmacosx-version-min=@macosx_dep_target@ \
 			@OPTOPTS@

diff --git a/aclocal.m4 b/aclocal.m4
index e5d36f1..1aadba7 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -12,10 +12,22 @@ AC_DEFUN([DUTI_CHECK_SDK],

 	darwin9*)
 	    sdk="/Developer/SDKs/MacOSX10.5.sdk"
+	    macosx_arches="-arch i386 -arch ppc"
 	    ;;

 	darwin10*)
 	    sdk="/Developer/SDKs/MacOSX10.6.sdk"
+	    macosx_arches="-arch i386 -arch ppc"
+	    ;;
+
+	darwin11*)
+	    sdk="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk"
+	    macosx_arches="-arch i386 -arch x86_64"
+	    ;;
+
+	darwin12*)
+	    sdk="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk"
+	    macosx_arches="-arch i386 -arch x86_64"
 	    ;;
 	*)
 	    AC_MSG_ERROR([${host_os} is not a supported system])
@@ -25,6 +37,7 @@ AC_DEFUN([DUTI_CHECK_SDK],
 	macosx_sdk=$sdk
     fi

+    AC_SUBST(macosx_arches)
     AC_SUBST(macosx_sdk)
     AC_MSG_RESULT($macosx_sdk)
 ])
@@ -49,6 +62,14 @@ AC_DEFUN([DUTI_CHECK_DEPLOYMENT_TARGET],
 	darwin10*)
 	    dep_target="10.6"
 	    ;;
+
+	darwin11*)
+	    dep_target="10.7"
+	    ;;
+
+	darwin12*)
+	    dep_target="10.8"
+	    ;;
     esac

     if test -z "$macosx_dep_target"; then
