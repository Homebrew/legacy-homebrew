require 'formula'

class Libfaketime < Formula
  homepage 'http://www.code-wizards.com/projects/libfaketime'
  url 'http://www.code-wizards.com/projects/libfaketime/libfaketime-0.9.1.tar.gz'
  sha1 'd53dfa1e1025f2f9729104b65789e4fadb2653a4'

  depends_on 'coreutils'

  def patches
    # Original had the wrong path in wrapper script for the dylib
    DATA
  end

  def install
    system "make -C src -f Makefile.MacOS"
    lib.install 'src/libfaketime.dylib.1'
    bin.install 'src/faketime'
  end
end

__END__
diff --git i/src/faketime w/src/faketime
index 8faf0fb..2d90201 100755
--- i/src/faketime
+++ w/src/faketime
@@ -16,7 +16,7 @@
 FTPL_PATH=/usr/lib/faketime
 
 # For Mac OS X users: Full path and name to libfaketime.dylib.1 
-MAC_FTPL_PATH=./libfaketime.dylib.1
+MAC_FTPL_PATH=HOMEBREW_PREFIX/lib/libfaketime.dylib.1
 
 offset="$1"
 
