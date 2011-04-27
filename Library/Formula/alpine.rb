require 'formula'

class Alpine < Formula
  url 'ftp://ftp.cac.washington.edu/alpine/alpine-2.00.tar.gz'
  homepage 'http://www.washington.edu/alpine/'
  md5 '0f4757167baf5c73aa44f2ffa4860093'

  def patches
    DATA unless MacOS.snow_leopard?
  end

  def install
    ENV.j1
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-ssl-include-dir=/usr/include/openssl"
    system "make install"
  end
end

__END__
diff -rc alpine-2.00/imap/Makefile alpine-2.00-10.6/imap/Makefile
*** alpine-2.00/imap/Makefile	2008-06-04 19:43:35.000000000 +0100
--- alpine-2.00-10.6/imap/Makefile	2009-09-02 10:55:38.000000000 +0100
***************
*** 418,424 ****
  	$(TOUCH) ip6
  	$(BUILD) BUILDTYPE=osx IP=$(IP6) EXTRAAUTHENTICATORS="$(EXTRAAUTHENTICATORS) gss" \
  	PASSWDTYPE=pam \
- 	EXTRACFLAGS="$(EXTRACFLAGS) -DMAC_OSX_KLUDGE=1" \
  	SPECIALS="SSLINCLUDE=/usr/include/openssl SSLLIB=/usr/lib SSLCERTS=/System/Library/OpenSSL/certs SSLKEYS=/System/Library/OpenSSL/private GSSINCLUDE=/usr/include GSSLIB=/usr/lib PAMDLFLAGS=-lpam"
  
  osx:	osxok an
--- 418,423 ----
diff -rc alpine-2.00/imap/src/osdep/unix/ckp_pam.c alpine-2.00-10.6/imap/src/osdep/unix/ckp_pam.c
*** alpine-2.00/imap/src/osdep/unix/ckp_pam.c	2008-06-04 19:18:34.000000000 +0100
--- alpine-2.00-10.6/imap/src/osdep/unix/ckp_pam.c	2009-09-02 10:56:36.000000000 +0100
***************
*** 27,37 ****
   */
  
  
- #ifdef MAC_OSX_KLUDGE		/* why can't Apple be compatible? */
- #include <pam/pam_appl.h>
- #else
  #include <security/pam_appl.h>
- #endif
  
  struct checkpw_cred {
    char *uname;			/* user name */
--- 27,33 ----

