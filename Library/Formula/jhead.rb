class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "http://www.sentex.net/~mwandel/jhead/"
  url "http://www.sentex.net/~mwandel/jhead/jhead-3.00.tar.gz"
  sha256 "88cc01da018e242fe2e05db73f91b6288106858dd70f27506c4989a575d2895e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2df303bdee1a1ee76b6f8a450d762ee2e3ea5868198c2ed9991f5407c6a1267a" => :el_capitan
    sha256 "94515e8c91489d9de1ac3fb5176e4b40d7010ec239407c996589d6c8d841d658" => :yosemite
    sha256 "277c20e19ebc174dc46e65509de3bcecb4af986b217cf7fd27ac2b6fb909476e" => :mavericks
    sha256 "cc28907085b95ff54384eefb5650e1a363128b74da950a3a30f3d10c7c093f66" => :mountain_lion
  end

  # Patch to provide a proper install target to the Makefile. The patch has
  # been submitted upstream through email. We need to carry this patch until
  # upstream decides to incorporate it.
  patch :DATA

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/jhead", test_fixtures("test.jpg")
  end
end

__END__
--- a/makefile	2015-02-02 23:24:06.000000000 +0100
+++ b/makefile	2015-02-25 16:31:21.000000000 +0100
@@ -1,12 +1,18 @@
 #--------------------------------
 # jhead makefile for Unix
 #--------------------------------
+PREFIX=$(DESTDIR)/usr/local
+BINDIR=$(PREFIX)/bin
+DOCDIR=$(PREFIX)/share/doc/jhead
+MANDIR=$(PREFIX)/share/man/man1
 OBJ=.
 SRC=.
 CFLAGS:= $(CFLAGS) -O3 -Wall

 all: jhead

+docs = $(SRC)/usage.html
+
 objs = $(OBJ)/jhead.o $(OBJ)/jpgfile.o $(OBJ)/jpgqguess.o $(OBJ)/paths.o \
	$(OBJ)/exif.o $(OBJ)/iptc.o $(OBJ)/gpsinfo.o $(OBJ)/makernote.o

@@ -19,5 +25,8 @@
 clean:
	rm -f $(objs) jhead

-install:
-	cp jhead ${DESTDIR}/usr/local/bin/
+install: all
+	install -d $(BINDIR) $(DOCDIR) $(MANDIR)
+	install -m 0755 jhead $(BINDIR)
+	install -m 0644 $(docs) $(DOCDIR)
+	install -m 0644 jhead.1 $(MANDIR)
