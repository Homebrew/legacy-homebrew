require "formula"

class GpgAgent < Formula
  homepage "https://www.gnupg.org/"
  url "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.25.tar.bz2"
  sha1 "890d77d89f2d187382f95e83e386f2f7ba789436"

  bottle do
    revision 1
    sha1 "317d26e0f85fefeb9cccf9a05644aaf70f05c13f" => :mavericks
    sha1 "16630ed6be44545cf61c631aa0f0a7251499a7c0" => :mountain_lion
    sha1 "a1dc1f35ba61af4d9fbf0e592f14a274c18c5056" => :lion
  end

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pth"
  depends_on "pinentry"

  # Adjust package name to fit our scheme of packaging both
  # gnupg 1.x and 2.x, and gpg-agent separately
  patch :DATA

  def install
    # don't use Clang's internal stdint.h
    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-agent-only",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                          "--with-scdaemon-pgm=#{Formula["gnupg2"].opt_libexec}/scdaemon"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index abacb4e..3b50500 100755
--- a/configure
+++ b/configure
@@ -578,8 +578,8 @@ MFLAGS=
 MAKEFLAGS=
 
 # Identity of this package.
-PACKAGE_NAME='gnupg'
-PACKAGE_TARNAME='gnupg'
+PACKAGE_NAME='gpg-agent'
+PACKAGE_TARNAME='gpg-agent'
 PACKAGE_VERSION='2.0.25'
 PACKAGE_STRING='gnupg 2.0.25'
 PACKAGE_BUGREPORT='http://bugs.gnupg.org'
