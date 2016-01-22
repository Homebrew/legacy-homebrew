class Minbif < Formula
  desc "IRC-to-other-IM-networks gateway using Pidgin library"
  homepage "https://symlink.me/projects/minbif/wiki/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/m/minbif/minbif_1.0.5+git20150505.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/minbif/minbif_1.0.5+git20150505.orig.tar.gz"
  version "1.0.5-20150505"
  sha256 "4e264fce518a0281de9fc3d44450677c5fa91097a0597ef7a0d2a688ee66d40b"
  revision 1

  bottle do
    cellar :any
    sha256 "a2975f09ebf6254df989164f832f80e7bf9e7d65a6c160375ffff6512c2b10bd" => :el_capitan
    sha256 "78a992db3b47f3ecaf331d3f81d5920f99b611f2dec1f8cafa5b1d318bb87abc" => :yosemite
    sha256 "a2affd1a3d8691f4f794a7d20b4d45b03c0ef79f9253d4d4bb0fdda79e5fe30d" => :mavericks
  end

  option "with-pam", "Build with PAM support, patching for OSX PAM headers"

  deprecated_option "pam" => "with-pam"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "glib"
  depends_on "gettext"
  depends_on "pidgin"
  depends_on "gnutls"
  depends_on "imlib2" => :optional
  depends_on "libcaca" => :optional

  # Problem:  Apple doesn't have <security/pam_misc.h> so don't ask for it.
  # Reported: https://symlink.me/issues/917
  patch :DATA if build.with? "pam"

  def install
    inreplace "minbif.conf" do |s|
      s.gsub! "users = /var", "users = #{var}"
      s.gsub! "motd = /etc", "motd = #{etc}"
    end

    args = %W[
      PREFIX=#{prefix}
      ENABLE_MINBIF=ON
      ENABLE_PLUGIN=ON
      ENABLE_VIDEO=OFF
      ENABLE_TLS=ON
    ]
    args << "ENABLE_IMLIB=" + ((build.with? "imlib2") ? "ON" : "OFF")
    args << "ENABLE_CACA=" + ((build.with? "libcaca") ? "ON" : "OFF")
    args << "ENABLE_PAM=" + ((build.with? "pam") ? "ON" : "OFF")

    system "make", *args
    system "make", "install"

    (var/"lib/minbif/users").mkpath
  end

  def caveats; <<-EOS.undent
    Minbif must be passed its config as first argument:
        minbif #{etc}/minbif/minbif.conf

    Learn more about minbif: https://symlink.me/projects/minbif/wiki/Quick_start
    EOS
  end

  test do
    system "#{bin}/minbif", "--version"
  end
end

__END__
--- a/src/im/auth_pam.h	2012-05-14 02:44:27.000000000 -0700
+++ b/src/im/auth_pam.h	2012-10-12 10:16:47.000000000 -0700
@@ -21,7 +21,10 @@

 #include "auth.h"
 #include <security/pam_appl.h>
+
+#ifndef __APPLE__
 #include <security/pam_misc.h>
+#endif

 struct _pam_conv_func_data {
	bool update;
