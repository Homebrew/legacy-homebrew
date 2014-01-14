require "formula"

class Libcapsimage < Formula
  homepage "http://www.softpres.org"
  url "http://distfiles.exherbo.org/distfiles/libfs-capsimage-4.2.tar.gz"
  sha1 "4bcbfa92f7c693bdef1477cc2f9b6cbc70d62330"

  def patches
    DATA
  end

  def install
    cd "CAPSImage" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end
end

__END__
diff --git a/CAPSImage/Makefile.in b/CAPSImage/Makefile.in
--- a/CAPSImage/Makefile.in
+++ b/CAPSImage/Makefile.in
@@ -14,6 +14,8 @@
 LIBRARY		= @LIBRARY@
 OBJECTS		= @EXTRA_OBJECTS@ afxgen.o CapsAPI.o CapsEFDC.o CapsEMFM.o CapsFile.o CapsImgS.o CapsLdr.o Crc.o DiskEnc.o DiskImg.o
 
+DESTDIR		= @prefix@
+
 SUBDIRS		= include examples
 
 .PHONY: all clean distclean dist
@@ -53,7 +55,7 @@
 	$(TAR) czf $(distdir).tar.gz $(distdir)
 
 install:
-	mkdir -p $(DESTDIR)/usr/lib
-	mkdir -p $(DESTDIR)/usr/include/caps
-	cp libfs-capsimage.so.* $(DESTDIR)/usr/lib/
-	cp include/caps/*.h $(DESTDIR)/usr/include/caps/
+	mkdir -p $(DESTDIR)/lib
+	mkdir -p $(DESTDIR)/include/caps
+	cp libfs-capsimage.dylib $(DESTDIR)/lib/libcapsimage.dylib
+	cp include/caps/*.h $(DESTDIR)/include/caps/
