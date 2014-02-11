require 'formula'

class AlpineChappa < Formula
  homepage 'http://patches.freeiz.com/alpine/'
  url 'http://patches.freeiz.com/alpine/release/src/alpine-2.11.tar.xz'
  sha1 '656556f5d2e5ec7e3680d1760cd02aa3a0072c46'

  depends_on 'autoconf' => :build
  depends_on 'openssl'
  conflicts_with 'alpine'

  def patches
    p = []
    # Upstream builds are broken on Snow Leopard due to a hack put in
    # for prior versions of OS X. See:
    # http://trac.macports.org/ticket/20971
    p <<  "https://trac.macports.org/export/89747/trunk/dports/mail/alpine/files/alpine-osx-10.6.patch" if MacOS.version >= :snow_leopard
    # 1. Fix typo "oxs" in configure.ac.
    # 2. Don't hardcode OpenSSL location in imap Makefile.
    # 3. #ifdef DEBUG for stray use of global debug level var in web-alpine LDAP module.
    p << DATA
  end

  def install
    ENV.j1
    system "#{Formula.factory('autoconf').opt_prefix}/bin/autoconf configure.ac > configure"
    system "./configure", "--disable-debug",
                          "--with-ssl-certs-dir=#{etc}/openssl/certs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff -ur a/configure.ac b/configure.ac
--- a/configure.ac	2014-02-04 23:45:14.000000000 -0500
+++ b/configure.ac	2014-02-04 23:45:37.000000000 -0500
@@ -972,7 +972,7 @@
 	AC_CHECK_HEADER([security/pam_appl.h],
 	[
 	  alpine_PAM="yes"
-	  alpine_c_client_target="oxs"
+	  alpine_c_client_target="osx"
 	],
 	[	AC_CHECK_HEADER([pam/pam_appl.h],
 		[
diff -ur alpine-2.11.OLD/imap/Makefile alpine-2.11.NEW/imap/Makefile
--- alpine-2.11.OLD/imap/Makefile	2013-08-15 00:36:13.000000000 -0400
+++ alpine-2.11.NEW/imap/Makefile	2014-02-06 10:24:35.000000000 -0500
@@ -432,7 +432,7 @@
 osx:	osxok an
 	$(TOUCH) ip6
 	$(BUILD) BUILDTYPE=$@ IP=$(IP6) EXTRAAUTHENTICATORS="$(EXTRAAUTHENTICATORS) gss" \
-	SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib"
+	SPECIALS="SSLINCLUDE=HOMEBREW_PREFIX/opt/openssl/include/openssl SSLLIB=HOMEBREW_PREFIX/opt/openssl/lib SSLCERTS=HOMEBREW_PREFIX/etc/openssl/certs SSLKEYS=HOMEBREW_PREFIX/etc/openssl/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib"
 
 osxok:
 	@$(SH) -c '(test ! -f /usr/include/pam/pam_appl.h ) || make osxwarn'
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
