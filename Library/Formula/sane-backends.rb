class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://fossies.org/linux/misc/sane-backends-1.0.24.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/s/sane-backends/sane-backends_1.0.24.orig.tar.gz"
  sha256 "27c7085a54f1505d8b551e6f1e69d30e1ee57328b18429bb2225dabf4c45462d"
  bottle do
    revision 1
    sha1 "36cbd09583ba8282b149467de09e963d8c2c2a6f" => :yosemite
    sha1 "d12ff8d69dae245177c554c82dbe0acc9c31fd3d" => :mavericks
    sha1 "343224849f6824dba073499bcb0521abd76e9e23" => :mountain_lion
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
