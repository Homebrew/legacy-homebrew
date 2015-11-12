class Mvptree < Formula
  desc "Perceptual hash library"
  homepage "http://www.phash.org"
  url "http://www.phash.org/releases/mvptree-1.0.tar.gz"
  sha256 "cbb89e7368785f4823200d4ba81975cdabe77797d736047b1ea14b02e6a61839"

  bottle do
    cellar :any
    sha1 "3dce2cad2eacd0ce04dbb4707734d665e64d2fd9" => :mavericks
    sha1 "eded94da7a783b5d0f0d59459c76f6ad639f08e5" => :mountain_lion
    sha1 "4cfffe6141a3f2f7e3a2a01fb966580ecaa5b6d1" => :lion
  end

  # Patch submitted to upstream by mail
  # Fixes a "permission denied" problem in the Makefile
  patch :DATA

  def install
    lib.mkpath
    include.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
