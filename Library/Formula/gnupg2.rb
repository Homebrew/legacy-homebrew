require "formula"

class Gnupg2 < Formula
  homepage "https://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.25.tar.bz2"
  sha1 "890d77d89f2d187382f95e83e386f2f7ba789436"

  bottle do
    revision 1
    sha1 "72eb0a083cf2f395a7c09d61cd1606af27cf800f" => :mavericks
    sha1 "e13777dfd387f1de8ffd1160a37167ab3e1d99ed" => :mountain_lion
    sha1 "0d925112501a584e1a221d6811a23562183a2850" => :lion
  end

  option "8192", "Build with support for private keys of up to 8192 bits"

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pinentry"
  depends_on "pth"
  depends_on "gpg-agent"
  depends_on "dirmngr" => :recommended
  depends_on "libusb-compat" => :recommended
  depends_on "readline" => :optional

  # Fix hardcoded runtime data location
  # upstream: http://git.gnupg.org/cgi-bin/gitweb.cgi?p=gnupg.git;h=c3f08dc
  # Adjust package name to fit our scheme of packaging both gnupg 1.x and
  # 2.x, and gpg-agent separately, and adjust tests to fit this scheme
  patch :DATA

  def install
    inreplace "g10/keygen.c", "max=4096", "max=8192" if build.include? "8192"

    (var/"run").mkpath

    ENV.append "LDFLAGS", "-lresolv"

    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    agent = Formula["gpg-agent"].opt_prefix

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sbindir=#{bin}
      --enable-symcryptrun
      --disable-agent
      --with-agent-pgm=#{agent}/bin/gpg-agent
      --with-protect-tool-pgm=#{agent}/libexec/gpg-protect-tool
    ]

    if build.with? "readline"
      args << "--with-readline=#{Formula["readline"].opt_prefix}"
    end

    system "./configure", *args
    system "make"
    system "make check"
    system "make install"

    # Conflicts with a manpage from the 1.x formula, and
    # gpg-zip isn't installed by this formula anyway
    rm man1/"gpg-zip.1"
  end
end

__END__
diff --git a/common/homedir.c b/common/homedir.c
index 4b03cfe..c84f26f 100644
--- a/common/homedir.c
+++ b/common/homedir.c
@@ -472,7 +472,7 @@ dirmngr_socket_name (void)
     }
   return name;
 #else /*!HAVE_W32_SYSTEM*/
-  return "/var/run/dirmngr/socket";
+  return "HOMEBREW_PREFIX/var/run/dirmngr/socket";
 #endif /*!HAVE_W32_SYSTEM*/
 }
 
diff --git a/configure b/configure
index abacb4e..d61f227 100755
--- a/configure
+++ b/configure
@@ -578,8 +578,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gnupg2'
+PACKAGE_TARNAME='gnupg2'
 PACKAGE_VERSION='2.0.25'
 PACKAGE_STRING='gnupg 2.0.25'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'
diff --git a/tests/openpgp/Makefile.in b/tests/openpgp/Makefile.in
index c9ceb2d..f58c96e 100644
--- a/tests/openpgp/Makefile.in
+++ b/tests/openpgp/Makefile.in
@@ -312,11 +312,10 @@ GPG_IMPORT = ../../g10/gpg2 --homedir . \
 
 
 # Programs required before we can run these tests.
-required_pgms = ../../g10/gpg2 ../../agent/gpg-agent \
-                ../../tools/gpg-connect-agent
+required_pgms = ../../g10/gpg2 ../../tools/gpg-connect-agent
 
 TESTS_ENVIRONMENT = GNUPGHOME=$(abs_builddir) GPG_AGENT_INFO= LC_ALL=C \
-		    ../../agent/gpg-agent --quiet --daemon sh
+		    gpg-agent --quiet --daemon sh
 
 TESTS = version.test mds.test \
 	decrypt.test decrypt-dsa.test \
