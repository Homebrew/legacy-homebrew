require 'formula'

class Linenoise < Formula
  homepage 'https://github.com/antirez/linenoise'
  head 'https://github.com/antirez/linenoise', :using => :git
  sha1 '08a7dfd6243fe9691d87b937b2c8c9c6552bd67a'
  version '0.1'

  def patches
    # add dylib to the makefile
    DATA
  end

  def install
    system "make"
    lib.install 'liblinenoise.dylib'
  end

  test do
    # if this built successfully and runs then we're probably ok
    system "echo|./linenoise_example"
  end
end

__END__
diff --git a/Makefile b/Makefile
index a285410..a3c4fb5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,15 @@
+all: liblinenoise.dylib linenoise_example
+
+liblinenoise.dylib: linenoise.o
+	$(CC) -dynamiclib -o liblinenoise.dylib linenoise.o
+
+%.o: %.c
+	$(CC) $(CFLAGS) -o $@ -c $<
+
 linenoise_example: linenoise.h linenoise.c
 
 linenoise_example: linenoise.c example.c
 	$(CC) -Wall -W -Os -g -o linenoise_example linenoise.c example.c
 
 clean:
-	rm -f linenoise_example
+	rm -f linenoise_example liblinenoise.dylib
