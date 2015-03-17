class Sslsplit < Formula
  homepage "https://www.roe.ch/SSLsplit"
  url "https://github.com/droe/sslsplit/archive/0.4.11.tar.gz"
  sha256 "a33808f5d78000d1a919e61bbdfc48478ad40c1a9b09a0250b322f8954cc5ae0"

  depends_on "check" => :build
  depends_on "pkg-config" => :build

  depends_on "libevent"
  depends_on "openssl"

  # Patch to remove UID 0,GID 0 setting for install
  patch :DATA

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "test", "install"
  end

  test do
    system "#{bin}/sslsplit", "-V"
  end
end

__END__
--- a/GNUmakefile	2015-03-16 15:09:42.000000000 -0700
+++ b/GNUmakefile	2015-03-16 15:10:09.000000000 -0700
@@ -351,8 +351,8 @@
 	test -d $(DESTDIR)$(PREFIX)/bin || $(MKDIR) -p $(DESTDIR)$(PREFIX)/bin
 	test -d $(DESTDIR)$(PREFIX)/$(MANDIR)/man1 || \
 		$(MKDIR) -p $(DESTDIR)$(PREFIX)/$(MANDIR)/man1
-	$(INSTALL) -o 0 -g 0 -m 0755 $(TARGET) $(DESTDIR)$(PREFIX)/bin/
-	$(INSTALL) -o 0 -g 0 -m 0644 $(TARGET).1 $(DESTDIR)$(PREFIX)/$(MANDIR)/man1/
+	$(INSTALL) -m 0755 $(TARGET) $(DESTDIR)$(PREFIX)/bin/
+	$(INSTALL) -m 0644 $(TARGET).1 $(DESTDIR)$(PREFIX)/$(MANDIR)/man1/
 
 deinstall:
 	$(RM) -f $(DESTDIR)$(PREFIX)/bin/$(TARGET) $(DESTDIR)$(PREFIX)/$(MANDIR)/man1/$(TARGET).1
