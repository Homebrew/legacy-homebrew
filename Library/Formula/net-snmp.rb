require 'formula'

class NetSnmp < Formula
  homepage 'http://www.net-snmp.org/'
  url 'http://sourceforge.net/projects/net-snmp/files/net-snmp/5.7.1/net-snmp-5.7.1.tar.gz'
  md5 'c95d08fd5d93df0c11a2e1bdf0e01e0b'

  def patches
    # Fixes compile error on Lion, missing header darwin11.h
    # The patch is reported upstream and does not exist in HEAD as of 2012-03-30.
    # https://sourceforge.net/tracker/?func=detail&aid=3514049&group_id=12694&atid=312694
    if MacOS.lion?
      DATA if header_created?
    end
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
--- a/include/net-snmp/system/darwin11.h
+++ b/include/net-snmp/system/darwin11.h
@@ -44,9 +44,9 @@
 /*
  * This section defines Mac OS X 10.5 (and later) specific additions.
  */
-#define darwin 10
-#ifndef darwin10
-#   define darwin10 darwin
+#define darwin 11
+#ifndef darwin11
+#   define darwin11 darwin
 #endif
 
 /*
