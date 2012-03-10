require 'formula'

class Xspin < Formula
  url 'http://spinroot.com/spin/Src/xspin525.tcl'
  homepage 'http://spinroot.com/spin/Src/index.html'
  md5 '4b41ff53c1834168aa183def9036bbb7'
  version '5.2.5'

  depends_on 'spin'

  def patches
    DATA
  end

  def install
    inreplace "xspin525.tcl", "CELLAR", prefix
    bin.install "xspin525.tcl" => "xspin"
  end
end

# manual patching is required by the spin install process
__END__
diff --git a/xspin525.tcl b/xspin525.tcl
old mode 100644
new mode 100755
index 73fc6bf..444b0ad
--- a/xspin525.tcl
+++ b/xspin525.tcl
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
