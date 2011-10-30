require 'formula'

class Liboping < Formula
  url 'http://verplant.org/liboping/files/liboping-1.6.1.tar.bz2'
  homepage 'http://verplant.org/liboping/'
  sha256 'cf5c9ac217ddc653543785de50fae6b2595393efa9d73e2e1acb63dc48fb3983'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  # Patches from user Dvorak. See:
  # https://github.com/mxcl/homebrew/pull/8374
  def patches
    DATA
  end

  def caveats
    "Run oping and noping sudo'ed in order to avoid the 'Operation not permitted'"
  end
end

__END__
diff --git a/src/liboping.c b/src/liboping.c
index beef4f5..daa61c4 100644
--- a/src/liboping.c
+++ b/src/liboping.c
@@ -69,6 +69,9 @@
 # include <netdb.h>
 #endif

+#ifdef __APPLE__
+#define __APPLE_USE_RFC_3542
+#endif
 #if HAVE_NETINET_IN_SYSTM_H
 # include <netinet/in_systm.h>
 #endif
@@ -545,6 +548,7 @@ static int ping_receive_one (pingobj_t *obj, const pinghost_t *ph,
 						sizeof (recv_qos));
 				dprintf ("TOSv6 = 0x%02"PRIx8";\n", recv_qos);
 			} else
+#ifdef IPV6_HOPLIMIT
 			if (cmsg->cmsg_type == IPV6_HOPLIMIT)
 			{
 				memcpy (&recv_ttl, CMSG_DATA (cmsg),
@@ -552,6 +556,25 @@ static int ping_receive_one (pingobj_t *obj, const pinghost_t *ph,
 				dprintf ("TTLv6 = %i;\n", recv_ttl);
 			}
 			else
+#endif
+#ifdef IPV6_UNICAST_HOPS
+			if (cmsg->cmsg_type == IPV6_UNICAST_HOPS)
+			{
+				memcpy (&recv_ttl, CMSG_DATA (cmsg),
+						sizeof (recv_ttl));
+				dprintf ("TTLv6 = %i;\n", recv_ttl);
+			}
+			else
+#endif
+#ifdef IPV6_MULTICAST_HOPS
+			if (cmsg->cmsg_type == IPV6_MULTICAST_HOPS)
+			{
+				memcpy (&recv_ttl, CMSG_DATA (cmsg),
+						sizeof (recv_ttl));
+				dprintf ("TTLv6 = %i;\n", recv_ttl);
+			}
+			else
+#endif
 			{
 				dprintf ("Not handling option %i.\n",
 						cmsg->cmsg_type);
diff --git a/src/liboping.c b/src/liboping.c
index daa61c4..3467ca5 100644
--- a/src/liboping.c
+++ b/src/liboping.c
@@ -1563,10 +1563,12 @@ int ping_host_add (pingobj_t *obj, const char *host)
 		{
 			int opt;

+#ifdef IP_RECVTOS
 			/* Enable receiving the TOS field */
 			opt = 1;
 			setsockopt (ph->fd, IPPROTO_IP, IP_RECVTOS,
 					&opt, sizeof (opt));
+#endif

 			/* Enable receiving the TTL field */
 			opt = 1;
