require 'formula'

class Xspin <Formula
  url 'http://spinroot.com/spin/Src/xspin523.tcl'
  homepage 'http://spinroot.com/spin/Src/index.html'
  md5 '893eb05798802cea4f281daaf34ce190'
  version '5.2.3'

  depends_on 'spin'

  def patches
    DATA
  end

  def install
    inreplace "xspin523.tcl", "CELLAR", prefix
    bin.install "xspin523.tcl" => "xspin"
  end
end

# manual patching is required by the spin install process
__END__
diff --git a/xspin523.tcl b/xspin523.tcl
old mode 100644
new mode 100755
index 73fc6bf..444b0ad
--- a/xspin523.tcl
+++ b/xspin523.tcl
@@ -1,8 +1,9 @@
-#!/bin/sh
+#!/usr/bin/wish -f
 # the next line restarts using wish \
-exec wish c:/cygwin/bin/xspin -- $*
+exec wish CELLAR/bin/xspin -- $*
+
+ cd	;# enable to cd to home directory by default
 
-# cd	;# enable to cd to home directory by default
 
 # on PCs:
 # adjust the first argument to wish above with the name and
