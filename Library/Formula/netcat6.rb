require "formula"

class Netcat6 < Formula
  homepage "http://www.deepspace6.net/projects/netcat6.html"
  url "http://ftp.debian.org/debian/pool/main/n/nc6/nc6_1.0.orig.tar.gz"
  sha1 "50b1a3f7bfa610a2016727e5741791ad3a88bd07"

  option "silence-patch", "Use silence patch from Debian"

  if build.include? "silence-patch"
    patch :p0, :DATA
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    lines = `#{bin}/nc6 --version`.split("\n")
    assert_equal "nc6 version #{version}", lines[0]
    assert_equal 0, $?.exitstatus
  end
end

__END__
# wrap socket-type warnings in very_verbose_mode()
--- src/network.c	2006-01-19 14:46:23.000000000 -0800
+++ src/network.c.new	2014-01-17 11:02:10.000000000 -0800
@@ -21,10 +21,11 @@
  */
 #include "system.h"
 #include "network.h"
 #include "connection.h"
 #include "afindep.h"
+#include "parser.h"
 #ifdef ENABLE_BLUEZ
 #include "bluez.h"
 #endif/*ENABLE_BLUEZ*/

 #include <assert.h>
@@ -290,17 +291,20 @@
	assert(sock >= 0);

	/* announce the socket in very verbose mode */
	switch (socktype) {
	case SOCK_STREAM:
-		warning(_("using stream socket"));
+		if (very_verbose_mode())
+			warning(_("using stream socket"));
		break;
	case SOCK_DGRAM:
-		warning(_("using datagram socket"));
+		if (very_verbose_mode())
+			warning(_("using datagram socket"));
		break;
	case SOCK_SEQPACKET:
-		warning(_("using seqpacket socket"));
+		if (very_verbose_mode())
+			warning(_("using seqpacket socket"));
		break;
	default:
		fatal_internal("unsupported socket type %d", socktype);
	}
