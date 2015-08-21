class AircrackNg < Formula
  desc "Next-generation aircrack with lots of new features"
  homepage "http://aircrack-ng.org/"
  url "http://download.aircrack-ng.org/aircrack-ng-1.2-rc2.tar.gz"
  sha256 "ba5b3eda44254efc5b7c9f776eb756f7cc323ad5d0813c101e92edb483d157e9"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "sqlite"
  depends_on "openssl"

  # 1st patch: Remove root requirement from OUI update script. See:
  # https://github.com/Homebrew/homebrew/pull/12755
  patch :DATA
  # 2nd patch: Fix build errors by adding an OS X-friendly version of endian.h
  # http://trac.aircrack-ng.org/ticket/1609
  patch :p0 do
    url "http://trac.aircrack-ng.org/raw-attachment/ticket/1609/aircrack-ng-1.2-rc2.patch"
    sha256 "c70cd98c2b0a9463b0536776238459b6b38e86a813c4291ad1b6b5b9c5aa0e6c" 
  end

  def install
    system "make", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "mandir=#{man1}", "install"
  end

  def caveats;  <<-EOS.undent
    Run `airodump-ng-oui-update` install or update the Airodump-ng OUI file.
    EOS
  end
end

__END__
--- a/scripts/airodump-ng-oui-update
+++ b/scripts/airodump-ng-oui-update
@@ -7,25 +7,6 @@
 OUI_PATH="/usr/local/etc/aircrack-ng"
 AIRODUMP_NG_OUI="${OUI_PATH}/airodump-ng-oui.txt"
 OUI_IEEE="${OUI_PATH}/oui.txt"
-USERID=""
-
-
-# Make sure the user is root
-if [ x"`which id 2> /dev/null`" != "x" ]
-then
-	USERID="`id -u 2> /dev/null`"
-fi
-
-if [ x$USERID = "x" -a x$UID != "x" ]
-then
-	USERID=$UID
-fi
-
-if [ x$USERID != "x" -a x$USERID != "x0" ]
-then
-	echo Run it as root ; exit ;
-fi
-
 
 if [ ! -d "${OUI_PATH}" ]; then
 	mkdir -p ${OUI_PATH}


--- a/src/osdep/radiotap/platform.h	2015-08-10 15:19:47.000000000 -0500
+++ b/src/osdep/radiotap/platform.h	2015-08-10 15:19:38.000000000 -0500
@@ -3,8 +3,32 @@
 #ifndef _BSD_SOURCE
 #define _BSD_SOURCE
 #endif
-#include <endian.h>
+#ifdef __APPLE__
+#include <machine/endian.h>
+#include <libkern/OSByteOrder.h>
 
+#define htobe16(x) OSSwapHostToBigInt16(x)
+#define htole16(x) OSSwapHostToLittleInt16(x)
+#define be16toh(x) OSSwapBigToHostInt16(x)
+#define le16toh(x) OSSwapLittleToHostInt16(x)
+
+#define htobe32(x) OSSwapHostToBigInt32(x)
+#define htole32(x) OSSwapHostToLittleInt32(x)
+#define be32toh(x) OSSwapBigToHostInt32(x)
+#define le32toh(x) OSSwapLittleToHostInt32(x)
+
+#define htobe64(x) OSSwapHostToBigInt64(x)
+#define htole64(x) OSSwapHostToLittleInt64(x)
+#define be64toh(x) OSSwapBigToHostInt64(x)
+#define le64toh(x) OSSwapLittleToHostInt64(x)
+
+#define __BIG_ENDIAN    BIG_ENDIAN
+#define __LITTLE_ENDIAN LITTLE_ENDIAN
+#define __BYTE_ORDER    BYTE_ORDER
+#else
+#include 
+#include 
+#endif
 #define le16_to_cpu		le16toh
 #define le32_to_cpu		le32toh
 #define get_unaligned(p)					\
