class Lysp < Formula
  desc "Small Lisp interpreter"
  homepage "http://www.piumarta.com/software/lysp/"
  url "http://www.piumarta.com/software/lysp/lysp-1.1.tar.gz"
  sha256 "436a8401f8a5cc4f32108838ac89c0d132ec727239d6023b9b67468485509641"

  depends_on "bdw-gc"

  fails_with :clang do
    build 500
    cause "use of unknown builtin '__builtin_return'"
  end

  # Use our CFLAGS
  patch :DATA

  def install
    system "make"
    bin.install "lysp", "gclysp"
  end
end

__END__
diff --git a/Makefile b/Makefile
index fc3f5d9..0b0e20d 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,3 @@
-CFLAGS  = -O  -g -Wall
-CFLAGSO = -O3 -g -Wall -DNDEBUG
-CFLAGSs = -Os -g -Wall -DNDEBUG
 LDLIBS  = -rdynamic
 
 all : lysp gclysp
@@ -10,15 +7,15 @@ lysp : lysp.c gc.c
 	size $@
 
 olysp: lysp.c gc.c
-	$(CC) $(CFLAGSO) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
+	$(CC) $(CFLAGS) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
 	size $@
 
 ulysp: lysp.c gc.c
-	$(CC) $(CFLAGSs) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
+	$(CC) $(CFLAGS) -DBDWGC=0 -o $@ lysp.c gc.c $(LDLIBS) -ldl
 	size $@
 
 gclysp: lysp.c
-	$(CC) $(CFLAGSO) -DBDWGC=1  -o $@ lysp.c $(LDLIBS) -lgc
+	$(CC) $(CFLAGS) -DBDWGC=1  -o $@ lysp.c $(LDLIBS) -lgc
 	size $@
 
 run : all
