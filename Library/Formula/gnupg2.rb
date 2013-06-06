require 'formula'

class Gnupg2 < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.19.tar.bz2'
  sha1 '190c09e6688f688fb0a5cf884d01e240d957ac1f'

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
  def patches; DATA; end

  def install
    (var/'run').mkpath

    # so we don't use Clang's internal stdint.h
    ENV['gl_cv_absolute_stdint_h'] = '/usr/include/stdint.h'

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
 

diff --git a/configure b/configure
index 829fc79..684213e 100755
--- a/configure
+++ b/configure
@@ -558,8 +558,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gnupg2'
+PACKAGE_TARNAME='gnupg2'
 PACKAGE_VERSION='2.0.19'
 PACKAGE_STRING='gnupg 2.0.19'
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
