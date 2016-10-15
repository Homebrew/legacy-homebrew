class Linenoise < Formula
  homepage "https://github.com/antirez/linenoise"
  url "https://github.com/antirez/linenoise/archive/1.0.tar.gz"
  sha256 "f5054a4fe120d43d85427cf58af93e56b9bb80389d507a9bec9b75531a340014"

  # Added patch to build linenoise as a dynamic library
  # Upstream Issue: https://github.com/antirez/linenoise/issues/94
  patch :DATA

  def install
    system "make"
    lib.install "liblinenoise.dylib"
    include.install "linenoise.h"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <stdio.h>
    #include "linenoise.h"

    int main() {
      linenoiseHistoryAdd("test");
      return 0;
    }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-llinenoise", "-o", "test"
    system "./test"
  end
end

__END__
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
