class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://fossies.org/linux/misc/sane-backends-1.0.24.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.24.orig.tar.gz"
  sha256 "27c7085a54f1505d8b551e6f1e69d30e1ee57328b18429bb2225dabf4c45462d"
  bottle do
    revision 1
    sha256 "e8cd147368ca911b15da016a09cb3d0b58843b5169291a75fe2a42fed7c9c887" => :el_capitan
    sha256 "006f73ab657625408f5d56ec1596498b911781164db60cc4518370b2a08686f3" => :yosemite
    sha256 "168d5dc5f38b6e568f2d757de77dc86c7b3bab1a84a50f1b30103eb9ba9bf367" => :mavericks
    sha256 "483533ac9a7d48d15350afaed266ac9472cd8c945fdd34d610253253e3c384e7" => :mountain_lion
  end

  revision 1

  option :universal

  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libusb-compat"
  depends_on "openssl"

  # Fixes u_long missing error. Reported upstream:
  # https://github.com/fab1an/homebrew/commit/2a716f1a2b07705aa891e2c7fbb5148506aa5a01
  # When updating this formula, check on the usptream status of this patch.
  patch :DATA

  def install
    ENV.universal_binary if build.universal?
    ENV.j1 # Makefile does not seem to be parallel-safe
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--enable-libusb",
                          "--disable-latex"
    system "make"
    system "make", "install"

    # Some drivers require a lockfile
    (var+"lock/sane").mkpath
  end
end

__END__
diff --git a/include/sane/sane.h.orig b/include/sane/sane.h
index 5320b4a..6cb7090 100644
--- a/include/sane/sane.h.orig
+++ b/include/sane/sane.h
@@ -20,6 +20,9 @@
 extern "C" {
 #endif
 
+// Fixes u_long missing error
+#include <sys/types.h>
+
 /*
  * SANE types and defines
  */
