class Monkeysphere < Formula
  desc "Use the OpenPGP web of trust to verify ssh connections"
  homepage "http://web.monkeysphere.info/"
  url "http://archive.monkeysphere.info/debian/pool/monkeysphere/m/monkeysphere/monkeysphere_0.36.orig.tar.gz"
  sha256 "6ae4edeff2cc29b6913346e15b61500ea7cc06d761a9f42e67de83b7d2607be7"

  head "git://git.monkeysphere.info/monkeysphere"

  depends_on "Crypt::OpenSSL::Bignum" => :perl

  patch :DATA

  def install
    ENV["PREFIX"] = "#{prefix}"
    ENV["ETCPREFIX"] = "#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile b/Makefile
index a37aa8f..36fe1ce 100755
--- a/Makefile
+++ b/Makefile
@@ -45 +45 @@ install: all installman
-	sed -i 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/bin/monkeysphere
+	sed -i '' 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/bin/monkeysphere
@@ -47 +47 @@ install: all installman
-	sed -i 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/sbin/monkeysphere-host
+	sed -i '' 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/sbin/monkeysphere-host
@@ -49 +49 @@ install: all installman
-	sed -i 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/sbin/monkeysphere-authentication
+	sed -i '' 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/sbin/monkeysphere-authentication
@@ -53,2 +53,2 @@ install: all installman
-	sed -i 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(PREFIX)/share/monkeysphere/defaultenv
-	sed -i 's:__SYSDATADIR_PREFIX__:$(LOCALSTATEDIR):' $(DESTDIR)$(PREFIX)/share/monkeysphere/defaultenv
+	sed -i '' 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(PREFIX)/share/monkeysphere/defaultenv
+	sed -i '' 's:__SYSDATADIR_PREFIX__:$(LOCALSTATEDIR):' $(DESTDIR)$(PREFIX)/share/monkeysphere/defaultenv
@@ -61,2 +61,2 @@ install: all installman
-	sed -i 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/share/monkeysphere/transitions/0.23
-	sed -i 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/share/monkeysphere/transitions/0.28
+	sed -i '' 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/share/monkeysphere/transitions/0.23
+	sed -i '' 's:__SYSSHAREDIR_PREFIX__:$(PREFIX):' $(DESTDIR)$(PREFIX)/share/monkeysphere/transitions/0.28
@@ -83 +83 @@ installman:
-	sed -i 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(MANPREFIX)/man1/monkeysphere.1
+	sed -i '' 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(MANPREFIX)/man1/monkeysphere.1
@@ -86,2 +86,2 @@ installman:
-	sed -i 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-host.8
-	sed -i 's:__SYSDATADIR_PREFIX__:$(LOCALSTATEDIR):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-host.8
+	sed -i '' 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-host.8
+	sed -i '' 's:__SYSDATADIR_PREFIX__:$(LOCALSTATEDIR):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-host.8
@@ -90,2 +90,2 @@ installman:
-	sed -i 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-authentication.8
-	sed -i 's:__SYSDATADIR_PREFIX__:$(LOCALSTATEDIR):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-authentication.8
+	sed -i '' 's:__SYSCONFDIR_PREFIX__:$(ETCPREFIX):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-authentication.8
+	sed -i '' 's:__SYSDATADIR_PREFIX__:$(LOCALSTATEDIR):' $(DESTDIR)$(MANPREFIX)/man8/monkeysphere-authentication.8
