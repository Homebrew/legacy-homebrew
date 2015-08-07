class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "http://www.sentex.net/~mwandel/jhead/"
  url "http://www.sentex.net/~mwandel/jhead/jhead-3.00.tar.gz"
  sha256 "88cc01da018e242fe2e05db73f91b6288106858dd70f27506c4989a575d2895e"

  bottle do
    cellar :any
    sha1 "185afa273417b275ff636c040ddcaef805bbf73f" => :yosemite
    sha1 "00babbf26b32bc6b51b1e029209ad998cb579dd1" => :mavericks
    sha1 "af148787c63b3fc3c4dc107f98ca72e54dececa0" => :mountain_lion
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
