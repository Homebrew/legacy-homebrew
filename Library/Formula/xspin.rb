class Xspin < Formula
  desc "Software verification tool (developed at Bell Labs)"
  homepage "https://spinroot.com/spin/Src/index.html"
  url "https://spinroot.com/spin/Src/xspin525.tcl"
  version "5.2.5"
  sha256 "e23d8d562e39db6fe73570e52ee895cd806d15c3e52e638299cbc1eb61289eb6"

  bottle do
    cellar :any_skip_relocation
    sha256 "896d3acc7e60648410ff86b1f8e744059bb71015900360fc18b3a75537e2c13e" => :el_capitan
    sha256 "2ff10f844a1c09cc99bf8e630bde4e191a450697ab6ea286c85bfb66670db405" => :yosemite
    sha256 "a1b19b1227fc19b6ea00cfea5a49955a82d180521e8df29d68842b465e5b4b89" => :mavericks
  end

  depends_on "spin"

  patch :DATA

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
