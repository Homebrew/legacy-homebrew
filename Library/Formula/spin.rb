require 'formula'

class Spin < Formula
  homepage 'http://spinroot.com/spin/whatispin.html'
  url 'http://spinroot.com/spin/Src/spin623.tar.gz'
  version '6.2.3'
  sha1 'af4e809627ac3d33d2125569d63fde5515659ef4'

  fails_with :llvm do
    build 2334
  end

  # replace -DPC with -DMAC in makefile CFLAGS
  def patches
    DATA
  end

  def install
    ENV.deparallelize

    cd("Src#{version}") do
      system "make"
      bin.install "spin"
    end

    man1.install "Man/spin.1"
  end
end

# manual patching is required by the spin install process
__END__
diff --git a/Src6.2.3/makefile b/Src6.2.3/makefile
index 02d2a02..7687e0a 100644
--- a/Src6.2.3/makefile
+++ b/Src6.2.3/makefile
@@ -13,12 +13,12 @@
 
 # see also ./make_pc for a simpler script, not requiring make
 
-CC=gcc
-CFLAGS=-O2 -DNXT	# on some systems add: -I/usr/include
+#CC=gcc
+#CFLAGS=-O2 -DNXT	# on some systems add: -I/usr/include
 
 # CC=gcc -m32 	# 32bit compilation on a 64bit system
 # for a more picky compilation use gcc-4 and:
-# CFLAGS=-std=c99 -Wstrict-prototypes -pedantic -fno-strength-reduce -fno-builtin -W -Wshadow -Wpointer-arith -Wcast-qual -Winline -Wall -g -DNXT -DPC
+CFLAGS=-std=c99 -Wstrict-prototypes -pedantic -fno-strength-reduce -fno-builtin -W -Wshadow -Wpointer-arith -Wcast-qual -Winline -Wall -g -DNXT -DMAC
 
 # on OS2:		spin -Picc -E/Pd+ -E/Q+
 # for Visual C++:	spin -PCL  -E/E
