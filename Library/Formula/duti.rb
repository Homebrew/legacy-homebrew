require 'formula'

class Duti < Formula
  homepage 'http://duti.org/'
  url 'https://github.com/downloads/fitterhappier/duti/duti-1.5.1.tar.gz'
  sha1 'ac199f936180a3ac62100ae9a31e107a45330557'

  head 'https://github.com/fitterhappier/duti.git'

  # Replaces arches with the string "@@ARCH@@" so we can fix it post-configure
  def patches
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    real_arch = MacOS.prefer_64_bit? ? "x86_64" : "i386"
    inreplace "Makefile", "@@ARCH@@", real_arch
    system "make install"
  end

  def test
    system "#{bin}/duti", "-x", "txt"
  end
end

__END__
diff --git a/configure b/configure
index de1f8e5..de9bcdf 100755
--- a/configure
+++ b/configure
@@ -2907,17 +2907,17 @@ fi
 
 	darwin10*)
 	    sdk="/Developer/SDKs/MacOSX10.6.sdk"
-	    macosx_arches="-arch i386 -arch ppc"
+	    macosx_arches="-arch @@ARCH@@"
 	    ;;
 
 	darwin11*)
 	    sdk="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk"
-	    macosx_arches="-arch i386 -arch x86_64"
+	    macosx_arches="-arch @@ARCH@@"
 	    ;;
 
 	darwin12*)
 	    sdk="/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk"
-	    macosx_arches="-arch i386 -arch x86_64"
+	    macosx_arches="-arch @@ARCH@@"
 	    ;;
 	*)
 	    { { echo "$as_me:$LINENO: error: ${host_os} is not a supported system" >&5
