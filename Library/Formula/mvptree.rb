require "formula"

class Mvptree < Formula
  homepage "http://www.phash.org"
  url "http://www.phash.org/releases/mvptree-1.0.tar.gz"
  sha1 "586bdc458116bed61caf7310804a70d55af9ce6e"

  # Patch submitted to upstream by mail
  # Fixes a "permission denied" problem in the Makefile
  patch :DATA

  def install
    lib.mkpath
    include.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    (testpath/'test.c').write <<-EOS.undent
      #include <stdio.h>
      #include <mvptree.h>
      int main() {
        MVPDP *pt = dp_alloc(MVP_BYTEARRAY);
        dp_free(pt, (MVPFreeFunc)0);
        return 0;
      }
    EOS
    system ENV.cc, "-g", "-c", "test.c", "-o", "test.o"
    system ENV.cc, "-g", "test.o", "#{lib}/libmvptree.a", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/Makefile b/Makefile
index bb155e2..29876b1 100644
--- a/Makefile
+++ b/Makefile
@@ -43,8 +43,9 @@ clean :

 install : $(HFLS) $(LIBRARY)
	install -c -m 444 $(HFLS) $(DESTDIR)/include
-	install -c -m 444 $(LIBRARY) $(DESTDIR)/lib
+	install -c -m 644 $(LIBRARY) $(DESTDIR)/lib
	$(RANLIB) $(DESTDIR)/lib/$(LIBRARY)
+	chmod 444 $(DESTDIR)/lib/$(LIBRARY)

 $(LIBRARY) : $(OBJS)
	ar cr $(LIBRARY) $?
