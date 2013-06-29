require 'formula'

class Miredo < Formula
  homepage 'http://www.remlab.net/miredo/'
  url 'http://www.remlab.net/files/miredo/miredo-1.2.5.tar.xz'
  sha1 '3aa4f35e78ffaca2c8652f428401be6e384888c9'

  depends_on 'xz' => :build
  depends_on 'judy'

  def patches
    DATA
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
    You must also install tuntap.

    The TunTap project provides kernel extensions for Mac OS X that allow
    creation of virtual network interfaces.

    http://tuntaposx.sourceforge.net/

    Because these are kernel extensions, there is no Homebrew formula for tuntap.
    EOS
  end
end

__END__
diff -ur a/misc/miredo.conf-in b/misc/miredo.conf-in
--- a/misc/miredo.conf-in	2009-07-06 10:56:14.000000000 -0500
+++ b/misc/miredo.conf-in	2012-06-07 15:09:34.000000000 -0500
@@ -8,7 +8,7 @@
 #RelayType client

 # Name of the network tunneling interface.
-InterfaceName	teredo
+#InterfaceName	teredo

 # Depending on the local firewall/NAT rules, you might need to force
 # Miredo to use a fixed UDP port and or IPv4 address.
diff -ur a/src/relayd.c b/src/relayd.c
--- a/src/relayd.c	2012-03-02 11:21:57.000000000 -0600
+++ b/src/relayd.c	2012-06-07 14:49:08.000000000 -0500
@@ -257,9 +257,21 @@
	memcpy (&s.addr, addr, sizeof (s.addr));
	s.mtu = (uint16_t)mtu;

+#ifdef MSG_NOSIGNAL
	if ((send (fd, &s, sizeof (s), MSG_NOSIGNAL) != sizeof (s))
	 || (recv (fd, &res, sizeof (res), MSG_WAITALL) != sizeof (res)))
		return -1;
+#else
+	int set = 1;
+	setsockopt(fd, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
+
+	if ((send (fd, &s, sizeof (s), 0) != sizeof (s))
+	 || (recv (fd, &res, sizeof (res), MSG_WAITALL) != sizeof (res)))
+		res = -1;
+
+	set = 0;
+	setsockopt(fd, SOL_SOCKET, SO_NOSIGPIPE, (void *)&set, sizeof(int));
+#endif

	return res;
 }
