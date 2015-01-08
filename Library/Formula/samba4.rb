require 'formula'

class Samba < Formula
  homepage 'http://samba.org/'
  url 'http://www.samba.org/samba/ftp/stable/samba-4.1.14.tar.gz'
  sha1 'db536187b4450adc610678fc8423cb1bfdc57836'

  conflicts_with 'talloc', :because => 'both install `include/talloc.h`'
  conflicts_with 'samba', :because => 'don´t install both packages'
  
  depends_on "pkg-config" => :build
  depends_on "gnutls" => :recommended
  depends_on "popt" => :recommended  
  
  skip_clean 'private'
  skip_clean 'var/locks'

  # Fixes
  patch :DATA

  def install
    system "./buildtools/bin/waf configure", "--prefix=#{prefix}",
                                             "--with-configdir=#{prefix}/etc",
                                             "--without-ldap"
    system "./buildtools/bin/waf build"
    system "./buildtools/bin/waf install"    
    (prefix/'etc').mkpath
    touch prefix/'etc/smb.conf'
    (prefix/'private').mkpath
    (var/'locks').mkpath
  end

  plist_options :manual => 'smbd'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/smbd</string>
          <string>-s</string>
          <string>#{etc}/smb.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end

__END__
diff --git a/lib/crypto/md5.h b/lib/crypto/md5.h
index edae27f..010c7d3 100644
--- a/lib/crypto/md5.h
+++ b/lib/crypto/md5.h
@@ -22,6 +22,7 @@
 #define MD5Update(c,d,l)			CC_MD5_Update(c,d,l)
 #define MD5Final(m, c)				CC_MD5_Final((unsigned char *)m,c)
 #define MD5Context CC_MD5state_st
+#define MD5_CTX CC_MD5_CTX
 
 #else
 typedef struct MD5Context {
diff --git a/source3/wscript b/source3/wscript
index 10aa232..5b94d73 100644
--- a/source3/wscript
+++ b/source3/wscript
@@ -331,12 +331,28 @@ int main(int argc, char **argv)
 
     # Check if the compiler will optimize out functions
     conf.CHECK_CODE('''
-if (0) {
-    this_function_does_not_exist();
-} else {
-    return 1;
-}''', 'HAVE_COMPILER_WILL_OPTIMIZE_OUT_FNS',
-        msg="Checking if the compiler will optimize out functions")
+#include <sys/types.h>
+size_t __unsafe_string_function_usage_here_size_t__(void);
+#define CHECK_STRING_SIZE(d, len) (sizeof(d) != (len) && sizeof(d) != sizeof(char *))
+static size_t push_string_check_fn(void *dest, const char *src, size_t dest_len) {
+	return 0;
+}
+
+#define push_string_check(dest, src, dest_len) \
+    (CHECK_STRING_SIZE(dest, dest_len) \
+    ? __unsafe_string_function_usage_here_size_t__()	\
+    : push_string_check_fn(dest, src, dest_len))
+
+int main(int argc, char **argv) {
+    char outbuf[1024];
+    char *p = outbuf;
+    const char *foo = "bar";
+    p += 31 + push_string_check(p + 31, foo, sizeof(outbuf) - (p + 31 - outbuf));
+    return 0;
+ }''', 'HAVE_COMPILER_WILL_OPTIMIZE_OUT_FNS',
+            addmain=False,
+            add_headers=False,
+            msg="Checking if the compiler will optimize out functions")
 
     # Check if the compiler supports the LL suffix on long long integers
     # AIX needs this
