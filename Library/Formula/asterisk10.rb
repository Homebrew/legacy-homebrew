require 'formula'

class Asterisk10 < Formula
  homepage 'http://asterisk.org'
  url 'http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-10.11.0.tar.gz'
  sha1 'a678774bd6cb90fb4cefe115eb91a30228410288'
  
  depends_on 'openssl'
  depends_on 'libxml2'
  depends_on 'sqlite'
  
  env :std
  option 'make-samples', 'Install the sample config files. NOTE: WILL OVERWRITE ANY EXISTING CONFIGS!'
 
  def patches
      DATA
  end

  def install
    ENV['CC'] = 'gcc'
    ENV['CXX'] = 'g++'
    ENV['CXXFLAGS'] = ""
    ENV['CFLAGS'] = ''
    ENV['LDFLAGS'] = ''
    ENV['CPPFLAGS'] = ''
    system "./configure", 
            "--prefix=#{prefix}", 
            "--without-netsnmp", 
            "--with-ssl=#{opt_prefix}/openssl/"
    inreplace 'Makefile.rules', '-O6', '-Os'

    system "make"
    system "make install"
    system "make samples" if build.include? 'make-samples'
  end
  
  def test
    system "asterisk"
  end
end

__END__
##https://issues.asterisk.org/jira/browse/ASTERISK-17163
--- ./pbx/pbx_spool.c	2012-12-23 10:49:01.000000000 +0200
+++ ./pbx/pbx_spool.c	2012-12-23 10:48:43.000000000 +0200
@@ -53,6 +53,11 @@
 #include "asterisk/module.h"
 #include "asterisk/utils.h"
 #include "asterisk/options.h"
+/* Force filesystem polling on OSX */
+#ifdef __APPLE__
+    #undef HAVE_KQUEUE
+    #undef HAVE_INOTIFY
+#endif
