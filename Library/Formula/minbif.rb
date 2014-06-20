require 'formula'

# Official download has untrusted SSL cert, so use Debian

class Minbif < Formula
  homepage 'http://minbif.im/'
  url 'http://ftp.de.debian.org/debian/pool/main/m/minbif/minbif_1.0.5+git20120508.orig.tar.gz'
  version '1.0.5'
  sha1 '5827df8954e29df80d1e81ee5df354b76c5fd86a'
  revision 1

  option 'pam', 'Build with PAM support, patching for OSX PAM headers'

  depends_on 'pkg-config' => :build
  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'gettext'
  depends_on 'finch'
  depends_on 'gnutls'
  depends_on 'imlib2' => :optional
  depends_on 'libcaca' => :optional

  # Problem:  Apple doesn't have <security/pam_misc.h> so don't ask for it.
  # Reported: https://symlink.me/issues/917
  patch :DATA if build.include? 'pam'

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
    args << 'ENABLE_IMLIB=' + ((build.include? 'imlib2') ? 'ON' : 'OFF')
    args << 'ENABLE_CACA=' + ((build.include? 'libcaca') ? 'ON' : 'OFF')
    args << 'ENABLE_PAM=' + ((build.include? 'pam') ? 'ON' : 'OFF')

    system 'make', *args
    system 'make install'

    (var + "lib/minbif/users").mkpath
  end

  def caveats; <<-EOS.undent
    Minbif must be passed its config as first argument:
        minbif #{etc}/minbif/minbif.conf

    Learn more about minbif: http://minbif.im/Quick_start
    EOS
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
