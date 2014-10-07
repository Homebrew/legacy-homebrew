require "formula"

class Duti < Formula
  homepage "http://duti.org/"
  head "https://github.com/moretension/duti.git"
  url "https://github.com/moretension/duti/archive/duti-1.5.2.tar.gz"
  sha1 "1833c0a56646a132fa09bcb31c557d4393f19a3b"

  depends_on "autoconf" => :build

  if MacOS.version == :yosemite
    patch :DATA
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
end

__END__

diff --git a/aclocal.m4 b/aclocal.m4
index ed5d43a..ee08977 100644
--- a/aclocal.m4
+++ b/aclocal.m4
@@ -34,6 +34,11 @@ AC_DEFUN([DUTI_CHECK_SDK],
 	    sdk_path="${sdk_path}/MacOSX10.9.sdk"
 	    macosx_arches=""
 	    ;;
+
+	darwin14*)
+	    sdk_path="${sdk_path}/MacOSX10.10.sdk"
+	    macosx_arches=""
+	    ;;
 	*)
 	    AC_MSG_ERROR([${host_os} is not a supported system])
     esac
@@ -79,6 +84,10 @@ AC_DEFUN([DUTI_CHECK_DEPLOYMENT_TARGET],
 	darwin13*)
 	    dep_target="10.9"
 	    ;;
+
+	darwin14*)
+	    dep_target="10.10"
+	    ;;
     esac
 
     if test -z "$macosx_dep_target"; then
