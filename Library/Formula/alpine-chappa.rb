require "formula"

class AlpineChappa < Formula
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.11.tar.xz"
  sha1 "656556f5d2e5ec7e3680d1760cd02aa3a0072c46"

  depends_on "openssl"

  conflicts_with "alpine", :because => "both install an `alpine` binary"

  # Upstream builds are broken on Snow Leopard due to a hack put in for prior
  # versions of OS X. See: http://trac.macports.org/ticket/20971
  if MacOS.version >= :snow_leopard
    patch do
      url "https://trac.macports.org/export/89747/trunk/dports/mail/alpine/files/alpine-osx-10.6.patch"
      sha1 "8cc6b95b6aba844ceef8454868b8f2c205de9792"
    end
  end

  # Two patches that fix build problems:
  # 1. Don't hardcode OpenSSL location in imap Makefile. Homebrew-specific, so
  #    not submitted upstream. Submitted upstream to chappa@gmx.com.
  # 2. #ifdef DEBUG for stray use of global debug level var in web-alpine LDAP
  #    module. Submitted upstream to chappa@gmx.com.
  patch :DATA

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula['openssl'].prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff -ur alpine-2.11.OLD/imap/Makefile alpine-2.11.NEW/imap/Makefile
--- alpine-2.11.OLD/imap/Makefile	2013-08-15 00:36:13.000000000 -0400
+++ alpine-2.11.NEW/imap/Makefile	2014-04-09 16:37:45.000000000 -0400
@@ -427,7 +427,7 @@
	$(TOUCH) ip6
	$(BUILD) BUILDTYPE=osx IP=$(IP6) EXTRAAUTHENTICATORS="$(EXTRAAUTHENTICATORS) gss" \
	PASSWDTYPE=pam \
-	SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"
+	SPECIALS="GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"

 osx:	osxok an
	$(TOUCH) ip6
diff -urN alpine-2.11.OLD/web/src/alpined.d/alpineldap.c alpine-2.11.NEW/web/src/alpined.d/alpineldap.c
--- alpine-2.11.OLD/web/src/alpined.d/alpineldap.c	2013-08-15 00:36:01.000000000 -0400
+++ alpine-2.11.NEW/web/src/alpined.d/alpineldap.c	2014-02-06 11:47:22.000000000 -0500
@@ -106,7 +106,9 @@
     pine_state = new_pine_struct();
     ps_global  = pine_state;
     vars = ps_global->vars;
+#ifdef DEBUG
     debug = 0;
+#endif	/* DEBUG */

     for(i = 1 ; i < argc; i++){
         if(*argv[i] == '-'){
