require 'formula'

class Gnupg2 < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.18.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha1 '5ec2f718760cc3121970a140aeea004b64545c46'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pinentry'
  depends_on 'pth'
  depends_on 'gpg-agent'
  depends_on 'dirmngr' => :optional
  depends_on 'libusb-compat' => :optional

  def patches
    DATA
  end

  def install
    (var+'run').mkpath

    # so we don't use Clang's internal stdint.h
    ENV['gl_cv_absolute_stdint_h'] = '/usr/include/stdint.h'

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-symcryptrun",
                          "--disable-agent"
    system "make"
    system "make check"
    system "make install"

    # conflicts with a manpage from the 1.x formula, and
    # gpg-zip isn't installed by this formula anyway
    rm man1+'gpg-zip.1'
  end
end

__END__
# fix configure's failure to detect libcurl
# http://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=commit;h=57ef0d6
diff --git a/configure b/configure
index 3df3900..35c474f 100755
--- a/configure
+++ b/configure
@@ -9384,7 +9384,7 @@ else
 
            cat confdefs.h - <<_ACEOF >conftest.$ac_ext
 /* end confdefs.h.  */
-include <curl/curl.h>
+#include <curl/curl.h>
 int
 main ()
 {

# fix runtime data location
# http://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;a=commitdiff;h=c3f08dc
diff --git a/common/homedir.c b/common/homedir.c
index 5f2e31e..d797b68 100644
--- a/common/homedir.c
+++ b/common/homedir.c
@@ -365,7 +365,7 @@ dirmngr_socket_name (void)
     }
   return name;
 #else /*!HAVE_W32_SYSTEM*/
-  return "/var/run/dirmngr/socket";
+  return "HOMEBREW_PREFIX/var/run/dirmngr/socket";
 #endif /*!HAVE_W32_SYSTEM*/
 }
 

# rename package to avoid conflicts with our gnupg 1.x formula
diff --git a/configure b/configure
index 3df3900..b102aec 100755
--- a/configure
+++ b/configure
@@ -558,8 +558,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gnupg2'
+PACKAGE_TARNAME='gnupg2'
 PACKAGE_VERSION='2.0.18'
 PACKAGE_STRING='gnupg 2.0.18'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'

# fix tests to work with our "gpg-agent is a separate package" scheme
diff --git a/tests/openpgp/Makefile.in b/tests/openpgp/Makefile.in
index ab2f10f..1d3cace 100644
--- a/tests/openpgp/Makefile.in
+++ b/tests/openpgp/Makefile.in
@@ -286,11 +286,11 @@ GPG_IMPORT = ../../g10/gpg2 --homedir . \
 
 
 # Programs required before we can run these tests.
-required_pgms = ../../g10/gpg2 ../../agent/gpg-agent \
+required_pgms = ../../g10/gpg2 \
                 ../../tools/gpg-connect-agent
 
 TESTS_ENVIRONMENT = GNUPGHOME=$(abs_builddir) GPG_AGENT_INFO= LC_ALL=C \
-		    ../../agent/gpg-agent --quiet --daemon sh 
+		    gpg-agent --quiet --daemon sh 
 
 TESTS = version.test mds.test \
 	decrypt.test decrypt-dsa.test \
