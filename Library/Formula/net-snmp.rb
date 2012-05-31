require 'formula'

class NetSnmp < Formula
  homepage 'http://www.net-snmp.org/'
  url 'http://sourceforge.net/projects/net-snmp/files/net-snmp/5.7.1/net-snmp-5.7.1.tar.gz'
  md5 'c95d08fd5d93df0c11a2e1bdf0e01e0b'

  def patches
    # Fixes compile error on Lion, missing header darwin11.h
    # The patch is reported upstream and does not exist in HEAD as of 2012-03-30.
    # https://sourceforge.net/tracker/?func=detail&aid=3514049&group_id=12694&atid=312694
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-persistent-directory=#{var}/db/net-snmp",
                          "--with-defaults",
                          "--without-rpm",
                          "--with-mib-modules=host ucd-snmp/diskio",
                          "--without-kmem-usage"
    system "make"
    system "make install"
  end

  def header_created?
    cp 'include/net-snmp/system/darwin10.h', 'include/net-snmp/system/darwin11.h'
    return TRUE
  end
end

__END__
diff --git a/include/net-snmp/system/darwin11.h b/include/net-snmp/system/darwin11.h
new file mode 100644
index 0000000..fd5d9ab
--- /dev/null
+++ b/include/net-snmp/system/darwin11.h
@@ -0,0 +1,148 @@
+/*
+ * While Darwin 10 (aka, Mac OS X 10.6 Snow Leopard) is "BSD-like", it differs
+ * substantially enough to not warrant pretending it is a BSD flavor.
+ * This first section are the vestigal BSD remnants.
+ */
+/* Portions of this file are subject to the following copyright(s).  See
+ * the Net-SNMP's COPYING file for more details and other copyrights
+ * that may apply:
+ */
+/*
+ * Portions of this file are copyrighted by:
+ * Copyright (C) 2007 Apple, Inc. All rights reserved.
+ * Use is subject to license terms specified in the COPYING file
+ * distributed with the Net-SNMP package.
+ */
+
+/*
+ * BSD systems use a different method of looking up sockaddr_in values 
+ */
+/* #define NEED_KLGETSA 1 */
+
+/*
+ * ARP_Scan_Next needs a 4th ifIndex argument 
+ */
+#define ARP_SCAN_FOUR_ARGUMENTS 1
+
+#define CHECK_RT_FLAGS 1
+
+/*
+ * this is not good enough before freebsd3! 
+ */
+/* #undef HAVE_NET_IF_MIB_H */
+
+/*
+ * This section adds the relevant definitions from generic.h
+ * (a file we don't include here)
+ */
+
+/*
+ * udp_inpcb list symbol, e.g. for mibII/udpTable.c
+ */
+#define INP_NEXT_SYMBOL inp_next
+
+/*
+ * This section defines Mac OS X 10.5 (and later) specific additions.
+ */
+#define darwin 11
+#ifndef darwin11
+#   define darwin11 darwin
+#endif
+
+/*
+ * Mac OS X should only use the modern API and definitions.
+ */
+#ifndef NETSNMP_NO_LEGACY_DEFINITIONS
+#define NETSNMP_NO_LEGACY_DEFINITIONS 1
+#endif
+
+/*
+ * looks like the IFTable stuff works better than the mibII versions
+ */
+ 
+#define NETSNMP_INCLUDE_IFTABLE_REWRITES
+
+/*
+ * use new host resources files as well
+ */
+#define NETSNMP_INCLUDE_HRSWINST_REWRITES
+#define NETSNMP_INCLUDE_HRSWRUN_REWRITES
+#undef NETSNMP_INCLUDE_HRSWRUN_WRITE_SUPPORT
+#define NETSNMP_CAN_GET_DISK_LABEL 1
+
+/*
+ * Enabling this restricts the compiler to mostly public APIs.
+ */
+#ifndef __APPLE_API_STRICT_CONFORMANCE
+#define __APPLE_API_STRICT_CONFORMANCE 1
+#endif
+#ifndef __APPLE_API_UNSTABLE
+#define __APPLE_API_UNSTABLE 1
+#endif
+
+/*
+ * Darwin's tools are capable of building multiple architectures in one pass.
+ * As a result, platform definitions should be deferred until compile time.
+ */
+#ifdef BYTE_ORDER
+# undef WORDS_BIGENDIAN
+# if BYTE_ORDER == BIG_ENDIAN
+#  define WORDS_BIGENDIAN 1
+# endif
+#endif
+
+/*
+ * Darwin's tools are capable of building multiple architectures in one pass.
+ * As a result, platform definitions should be deferred until compile time.
+ */
+#ifdef BYTE_ORDER
+# undef WORDS_BIGENDIAN
+# if BYTE_ORDER == BIG_ENDIAN
+#  define WORDS_BIGENDIAN 1
+# endif
+#endif
+
+/*
+ * Although Darwin does have an fstab.h file, getfsfile etc. always return null.
+ * At least, as of 5.3.
+ */
+#undef HAVE_FSTAB_H
+
+#define SWAPFILE_DIR "/private/var/vm"
+#define SWAPFILE_PREFIX "swapfile"
+
+/*
+ * These apparently used to be in netinet/tcp_timers.h, but went away in
+ * 10.4.2. Define them here til we find out a way to get the real values.
+ */
+#define TCPTV_MIN       (  1*PR_SLOWHZ)         /* minimum allowable value */
+#define TCPTV_REXMTMAX  ( 64*PR_SLOWHZ)         /* max allowable REXMT value */
+
+/*
+ * Because Mac OS X is built on Mach, it does not provide a BSD-compatible
+ * VM statistics API.
+ */
+#define USE_MACH_HOST_STATISTICS 1
+
+/*
+ * This tells code that manipulates IPv6 that the structures are unified,
+ * i.e., IPv4 and IPv6 use the same structs.
+ * This should eventually be replaced with a configure directive.
+ */
+/* #define USE_UNIFIED_IPV6_STRUCTS 1 */
+#undef STRUCT_in6pcb_HAS_inp_vflag
+
+/*
+ * utility macro used in several darwin specific files
+ */
+#define SNMP_CFRelease(x) do { if (x) { CFRelease(x); x = NULL; } } while(0)
+
+/*
+ * Mac OS X runs on both PPC and Intel hardware,
+ *   which handle udpTable index values differently
+ */
+#include <TargetConditionals.h>
+#ifdef TARGET_RT_LITTLE_ENDIAN
+#define UDP_ADDRESSES_IN_HOST_ORDER 1
+#endif
+
