require 'formula'

class Logrotate < Formula
  homepage 'http://packages.debian.org/testing/admin/logrotate'
  url 'https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.8.3.tar.gz'
  sha1 '19d70e2cfb97c1cee32e0d709da990856311022a'

  depends_on 'popt'

  # Per MacPorts, let these variables be overridden by ENV vars.
  def patches
    DATA
  end

  def install
    # Otherwise defaults to /bin/gz
    ENV["COMPRESS_COMMAND"] = "/usr/bin/gzip"
    ENV["COMPRESS_EXT"] = ".gz"
    ENV["UNCOMPRESS_COMMAND"] = "/usr/bin/gunzip"

    system "make"
    sbin.install 'logrotate'
    man8.install 'logrotate.8'
    man5.install 'logrotate.conf.5'
    (prefix+'etc/logrotate/examples').install Dir['examples/*']
  end
end

__END__
diff --git a/Makefile b/Makefile
index d65a3f3..14d1f3f 100644
--- a/Makefile
+++ b/Makefile
@@ -76,6 +76,22 @@ ifneq ($(POPT_DIR),)
     LOADLIBES += -L$(POPT_DIR)
 endif
 
+ifneq ($(COMPRESS_COMMAND),)
+    CFLAGS += -DCOMPRESS_COMMAND=\"$(COMPRESS_COMMAND)\"
+endif
+
+ifneq ($(COMPRESS_EXT),)
+    CFLAGS += -DCOMPRESS_EXT=\"$(COMPRESS_EXT)\"
+endif
+
+ifneq ($(UNCOMPRESS_COMMAND),)
+    CFLAGS += -DUNCOMPRESS_COMMAND=\"$(UNCOMPRESS_COMMAND)\"
+endif
+
+ifneq ($(DEFAULT_MAIL_COMMAND),)
+    CFLAGS += -DDEFAULT_MAIL_COMMAND=\"$(DEFAULT_MAIL_COMMAND)\"
+endif
+
 ifneq ($(STATEFILE),)
     CFLAGS += -DSTATEFILE=\"$(STATEFILE)\"
 endif
