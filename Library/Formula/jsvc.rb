require 'formula'

class Jsvc < Formula
  homepage 'http://commons.apache.org/daemon/jsvc.html'
  url 'http://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.0.15-native-src.tar.gz'
  version '1.0.15'
  sha1 'f99fa9bcbc3faf6660e760af099eb003e2553b39'

  # Enable Java 7 JVMs: https://issues.apache.org/jira/browse/DAEMON-281
  patch :DATA

  def install
    ENV.append "CFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "LDFLAGS", "-arch #{MacOS.preferred_arch}"
    ENV.append "CPPFLAGS", "-I/System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers"

    prefix.install %w{ NOTICE.txt LICENSE.txt RELEASE-NOTES.txt }

    cd 'unix'
    system './configure', '--with-java=/System/Library/Frameworks/JavaVM.framework',
                          '--with-os-type=Headers'
    system 'make'
    bin.install 'jsvc'
  end
end

__END__
diff -r -u a/unix/native/java.c b/unix/native/java.c
--- a/unix/native/java.c  2013-03-28 13:53:58.000000000 +0100
+++ b/unix/native/java.c	2013-05-14 21:52:01.000000000 +0200
@@ -203,6 +203,13 @@
             return false;
         }
     }
+    if (stat(appf, &sb)) {
+        if (replace(appf, 1024, "$JAVA_HOME/../MacOS/libjli.dylib",
+                    "$JAVA_HOME", data->path) != 0) {
+            log_error("Cannot replace values in loader library");
+            return false;
+        }
+    }
     apph = dso_link(appf);
     if (apph == NULL) {
         log_error("Cannot load required shell library %s", appf);
diff -r -u a/unix/native/location.c b/unix/native/location.c
--- a/unix/native/location.c	2013-03-28 13:53:58.000000000 +0100
+++ b/unix/native/location.c	2013-05-14 21:50:31.000000000 +0200
@@ -144,6 +144,7 @@
 char *location_jvm_configured[] = {
 #if defined(OS_DARWIN)
     "$JAVA_HOME/../Libraries/lib$VM_NAME.dylib",
+    "$JAVA_HOME/jre/lib/$VM_NAME/libjvm.dylib",
 #elif defined(OS_CYGWIN)
     "$JAVA_HOME/jre/bin/$VM_NAME/jvm.dll",              /* Sun JDK 1.3 */
 #elif defined(OS_LINUX) || defined(OS_SOLARIS) || defined(OS_BSD) || defined(OS_FREEBSD) || defined(OS_TRU64)
