require 'formula'

class NoBdb5 < Requirement
  satisfy(:build_env => false) { !Formula["berkeley-db"].installed? }

  def message; <<-EOS.undent
    This software can fail to compile when Berkeley-DB 5.x is installed.
    You may need to try:
      brew unlink berkeley-db
      brew install squid
      brew link berkeley-db
    EOS
  end
end

class Squid < Formula
  homepage 'http://www.squid-cache.org/'
  url 'http://www.squid-cache.org/Versions/v3/3.3/squid-3.3.11.tar.gz'
  sha1 'e89812a51d4e88abac15c301d571d83549f2d81e'

  depends_on NoBdb5

  # fix building on mavericks
  # http://bugs.squid-cache.org/show_bug.cgi?id=3954
  patch :DATA if MacOS.version >= :mavericks

  def install
    # For --disable-eui, see:
    # http://squid-web-proxy-cache.1019090.n4.nabble.com/ERROR-ARP-MAC-EUI-operations-not-supported-on-this-operating-system-td4659335.html
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --enable-ssl
      --enable-ssl-crtd
      --disable-eui
      --enable-ipfw-transparent
    ]

    system "./configure", *args
    system "make install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/squid</string>
        <string>-N</string>
        <string>-d 1</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
    </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/compat/unsafe.h b/compat/unsafe.h
index d58f546..6c9f7ab 100644
--- a/compat/unsafe.h
+++ b/compat/unsafe.h
@@ -5,7 +5,7 @@
  * Trap unintentional use of functions unsafe for use within squid.
  */

-#if !SQUID_NO_STRING_BUFFER_PROTECT
+#if !SQUID_NO_STRING_BUFFER_PROTECT && 0
 #ifndef sprintf
 #define sprintf ERROR_sprintf_UNSAFE_IN_SQUID
 #endif
diff --git a/include/Array.h b/include/Array.h
index 8cee5fa..8f43522 100644
--- a/include/Array.h
+++ b/include/Array.h
@@ -35,6 +35,7 @@
  \todo CLEANUP: this file should be called Vector.h at least, and probably be replaced by STL Vector<C>
  */

+#include <iterator>
 #include "fatal.h"
 #include "util.h"

@@ -44,7 +45,7 @@
 /* iterator support */

 template <class C>
-class VectorIteratorBase
+class VectorIteratorBase : public std::iterator <std::forward_iterator_tag, typename C::value_type>
 {

 public:
