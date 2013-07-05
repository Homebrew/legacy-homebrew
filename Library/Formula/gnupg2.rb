require 'formula'

class Gnupg2 < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.20.tar.bz2'
  sha1 '7ddfefa37ee9da89a8aaa8f9059d251b4cd02562'

  depends_on 'libgpg-error'
  depends_on 'libgcrypt'
  depends_on 'libksba'
  depends_on 'libassuan'
  depends_on 'pinentry'
  depends_on 'pth'
  depends_on 'gpg-agent'
  depends_on 'dirmngr' => :recommended
  depends_on 'libusb-compat' => :recommended

  # Fix hardcoded runtime data location
  # upstream: http://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;h=c3f08dc
  # Adjust package name to fit our scheme of packaging both gnupg 1.x and
  # 2.x, and gpg-agent separately, and adjust tests to fit this scheme
  # Fix typo that breaks compilation:
  # http://lists.gnupg.org/pipermail/gnupg-users/2013-May/046652.html
  def patches; DATA; end

  def install
    (var/'run').mkpath

    ENV['gl_cv_absolute_stdint_h'] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-symcryptrun",
                          "--disable-agent",
                          "--with-agent-pgm=#{HOMEBREW_PREFIX}/bin/gpg-agent"
    system "make"
    system "make check"
    system "make install"

    # Conflicts with a manpage from the 1.x formula, and
    # gpg-zip isn't installed by this formula anyway
    rm man1/'gpg-zip.1'
  end
end

__END__
diff --git a/common/homedir.c b/common/homedir.c
index 5adf46a..d0c5dec 100644
--- a/common/homedir.c
+++ b/common/homedir.c
@@ -368,7 +368,7 @@ dirmngr_socket_name (void)
     }
   return name;
 #else /*!HAVE_W32_SYSTEM*/
-  return "/var/run/dirmngr/socket";
+  return "HOMEBREW_PREFIX/var/run/dirmngr/socket";
 #endif /*!HAVE_W32_SYSTEM*/
 }
 

diff --git a/configure b/configure
index 616d165..ae3126e 100755
--- a/configure
+++ b/configure
@@ -578,8 +578,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gnupg2'
+PACKAGE_TARNAME='gnupg2'
 PACKAGE_VERSION='2.0.20'
 PACKAGE_STRING='gnupg 2.0.20'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'

diff --git a/tests/openpgp/Makefile.in b/tests/openpgp/Makefile.in
index 1a617e7..1af2d4b 100644
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
  diff --git a/scd/pcsc-wrapper.c b/scd/pcsc-wrapper.c
  index 7d9415a..f3d92ff 100644
--- a/scd/pcsc-wrapper.c
+++ b/scd/pcsc-wrapper.c
@@ -66,7 +66,7 @@
 static int verbose;

 #if defined(__APPLE__) || defined(_WIN32) || defined(__CYGWIN__)
-typedef unsinged int pcsc_dword_t;
+typedef unsigned int pcsc_dword_t;
 #else
 typedef unsigned long pcsc_dword_t;
 #endif
