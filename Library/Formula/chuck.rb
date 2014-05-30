require "formula"

class Chuck < Formula
  homepage "http://chuck.cs.princeton.edu/"
  url "http://chuck.cs.princeton.edu/release/files/chuck-1.3.4.0.tgz"
  sha1 "d32faae2cb60fc81d2716b477cf2d54bc548d9c6"

  # Homebrew already takes care of setting the sysroot;
  # also lets the build work on CLT.
  patch :DATA

  def install
    system "make", "-C", "src", "osx"
    bin.install "src/chuck"
    (share/"chuck").install "examples"
  end
end

__END__
diff --git a/src/makefile.osx b/src/makefile.osx
index 4531ee1..cd4a910 100644
--- a/src/makefile.osx
+++ b/src/makefile.osx
@@ -2,8 +2,6 @@
 # FORCE_M32=-m32
 
 ifneq ($(shell sw_vers -productVersion | egrep '10\.[6789](\.[0-9]+)?'),)
-SDK=$(shell xcodebuild -sdk macosx -version | grep '^Path:' | sed 's/Path: \(.*\)/\1/')
-ISYSROOT=-isysroot $(SDK)
 LINK_EXTRAS=-F/System/Library/PrivateFrameworks \
     -weak_framework MultitouchSupport
 else
