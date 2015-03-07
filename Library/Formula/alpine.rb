require "formula"

class Alpine < Formula
  homepage "http://patches.freeiz.com/alpine/"
  url "http://patches.freeiz.com/alpine/release/src/alpine-2.11.tar.xz"
  sha1 "656556f5d2e5ec7e3680d1760cd02aa3a0072c46"

  bottle do
    sha1 "51fb44fd30777e0a64924689978e4f2d795176a5" => :yosemite
    sha1 "70ff0f3bf57301618a5e62eee32949626fe944e0" => :mavericks
    sha1 "bf5133161a796b895e07d0637ea4beae5457a96c" => :mountain_lion
  end

  depends_on "openssl"

  # Upstream builds are broken on Snow Leopard due to a hack put in for prior
  # versions of OS X. See: http://trac.macports.org/ticket/20971
  if MacOS.version >= :snow_leopard
    patch do
      url "https://trac.macports.org/export/89747/trunk/dports/mail/alpine/files/alpine-osx-10.6.patch"
      sha1 "8cc6b95b6aba844ceef8454868b8f2c205de9792"
    end
  end

  # Patch to fix Yosemite compile necessary due to different language in mach.h on 10.10.
  # Upstream reply: https://gist.github.com/DomT4/6a73cd8c6f8678d79479
  # Should be fixed in next stable release & can remove then. (Test first, though).
  if MacOS.version >= :yosemite
    patch do
      url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Alpine/yosemitemountains.diff"
      sha1 "04eddec32fe9a6d5cbbe9ed5d2980d428f84b56a"
    end
  end

  # Patch for tcl issues when Alpine is built against TCL 8.6.
  # Submitted upstream by Misty De Meo.
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/Alpine/tclfix.diff"
    sha1 "5dec826ebf05996a4efac0249417f9b837c71fad"
  end

  # Two patches that fix build problems:
  # 1. Don't hardcode OpenSSL location in imap Makefile. Homebrew-specific.
  # 2. #ifdef DEBUG for stray use of global debug level var in web-alpine LDAP module.
  # These are both fixed in the Alpha release of Alpine & will be in the next stable release.
  patch :DATA

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--with-ssl-dir=#{Formula["openssl"].prefix}",
                          "--with-ssl-certs-dir=#{etc}/openssl",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
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
