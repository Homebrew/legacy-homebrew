require "formula"

class Skalibs < Formula
  homepage "http://skarnet.org/software/skalibs"
  url "http://skarnet.org/software/skalibs/skalibs-1.6.0.0.tar.gz"
  sha1 "18f470af8e25561dcac699f3c7411067f5d5b4b3"

  # See http://www.mail-archive.com/skaware@list.skarnet.org/msg00059.html
  patch :DATA

  def install
    ENV.deparallelize

    cd "skalibs-#{version}" do
      # configure
      cd "conf-compile" do
        write "conf-defaultpath",        "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin"
        write "conf-etc",                "#{prefix}/etc"
        write "conf-install-command",    "#{bin}"
        write "conf-install-include",    "#{include}"
        write "conf-install-libexec",    "#{libexec}"
        write "conf-install-library",    "#{lib}"
        write "conf-install-library.so", "#{lib}"
        write "conf-install-sysdeps",    "#{prefix}/sysdeps"
        write "conf-striplibs",          "strip -x"

        rm_f  "flag-slashpackage"
        touch "flag-allstatic"
        touch "flag-forcedevr"
      end

      mkdir "#{prefix}/etc"
      system "make", "install"
    end
  end

  private

  def write(path, str)
    File.open(path, "w") {|f| f.write(str) }
  end
end

__END__
--- a/skalibs-1.6.0.0/src/libstddjb/getpeereid.h
+++ b/skalibs-1.6.0.0/src/libstddjb/getpeereid.h
@@ -3,6 +3,14 @@
 #ifndef GETPEEREID_H
 #define GETPEEREID_H

+#include "sysdeps.h"
+
+#ifdef HASGETPEEREID
+/* syscall exists - do nothing */
+
+#else
+
 extern int getpeereid (int, int *, int *) ;

 #endif
+#endif
--- a/skalibs-1.6.0.0/src/libstddjb/ipc_eid.c
+++ b/skalibs-1.6.0.0/src/libstddjb/ipc_eid.c
@@ -5,7 +5,7 @@

 int ipc_eid (int s, unsigned int *u, unsigned int *g)
 {
-  int dummyu, dummyg ;
+  unsigned int dummyu, dummyg ;
   if (getpeereid(s, &dummyu, &dummyg) < 0) return -1 ;
   *u = (unsigned int)dummyu ;
   *g = (unsigned int)dummyg ;
