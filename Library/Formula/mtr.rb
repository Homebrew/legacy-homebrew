require 'formula'

class Mtr < Formula
  homepage 'http://www.bitwizard.nl/mtr/'
  url  'ftp://ftp.bitwizard.nl/mtr/mtr-0.85.tar.gz'
  sha1 '6e79584265f733bea7f1b2cb13eeb48f10e96bba'

  head do
    url 'https://github.com/traviscross/mtr.git'
    depends_on :automake
  end

  depends_on 'pkg-config' => :build
  depends_on 'gtk+' => :optional
  depends_on 'glib' => :optional

  def patches; DATA; end

  def install
    # We need to add this because nameserver8_compat.h has been removed in Snow Leopard
    ENV['LIBS'] = "-lresolv"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--without-gtk" if build.without? 'gtk+'
    args << "--without-glib" if build.without? 'glib'
    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    mtr requires superuser privileges. You can either run the program
    via `sudo`, or change its ownership to root and set the setuid bit:

      sudo chown root:wheel #{sbin}/mtr
      sudo chmod u+s #{sbin}/mtr

    In any case, you should be certain that you trust the software you
    are executing with elevated privileges.
    EOS
  end
end

__END__
diff --git i/asn.c w/asn.c
index f384f19..3d1c1bc 100644
--- i/asn.c
+++ w/asn.c
@@ -21,6 +21,8 @@
 #include <stdlib.h>
 #include <sys/types.h>
 
+#include "config.h"
+
 #ifndef __APPLE__
 #define BIND_8_COMPAT
 #endif
@@ -35,7 +37,6 @@
 #include <sys/socket.h>
 #include <search.h>
 
-#include "config.h"
 #include "mtr.h"
 #include "asn.h"
 
