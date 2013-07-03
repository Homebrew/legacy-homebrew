require 'formula'

class Maven < Formula
  homepage 'http://maven.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.0.5/binaries/apache-maven-3.0.5-bin.tar.gz'
  sha1 'aecc0d3d67732939c0056d4a0d8510483ee1167e'

  # Detect Java using java_home.
  # This patch should be removed once Maven closes MNG-4226.
  # http://jira.codehaus.org/browse/MNG-4226
  def patches
    DATA
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["conf/settings.xml"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end

__END__
diff --git a/bin/mvn b/bin/mvn
index ba46c8e..d214611 100755
--- a/bin/mvn
+++ b/bin/mvn
@@ -54,11 +54,12 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   MINGW*) mingw=true;;
   Darwin*) darwin=true 
-           if [ -z "$JAVA_VERSION" ] ; then
-             JAVA_VERSION="CurrentJDK"
-           fi
            if [ -z "$JAVA_HOME" ] ; then
-             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
+             if [ -z "$JAVA_VERSION" ] ; then
+               JAVA_HOME=`/usr/libexec/java_home`
+             else
+               JAVA_HOME=`/usr/libexec/java_home -v ${JAVA_VERSION}`
+             fi
            fi
            ;;
 esac
diff --git a/bin/mvnDebug b/bin/mvnDebug
index 291e1e2..11f6f3e 100755
--- a/bin/mvnDebug
+++ b/bin/mvnDebug
@@ -58,11 +58,12 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   MINGW*) mingw=true;;
   Darwin*) darwin=true 
-           if [ -z "$JAVA_VERSION" ] ; then
-             JAVA_VERSION="CurrentJDK"
-           fi
            if [ -z "$JAVA_HOME" ] ; then
-             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
+             if [ -z "$JAVA_VERSION" ] ; then
+               JAVA_HOME=`/usr/libexec/java_home`
+             else
+               JAVA_HOME=`/usr/libexec/java_home -v ${JAVA_VERSION}`
+             fi
            fi
            ;;
 esac
diff --git a/bin/mvnyjp b/bin/mvnyjp
index b3e5e7e..de3631c 100755
--- a/bin/mvnyjp
+++ b/bin/mvnyjp
@@ -62,11 +62,12 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   MINGW*) mingw=true;;
   Darwin*) darwin=true 
-           if [ -z "$JAVA_VERSION" ] ; then
-             JAVA_VERSION="CurrentJDK"
-           fi
            if [ -z "$JAVA_HOME" ] ; then
-             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/${JAVA_VERSION}/Home
+             if [ -z "$JAVA_VERSION" ] ; then
+               JAVA_HOME=`/usr/libexec/java_home`
+             else
+               JAVA_HOME=`/usr/libexec/java_home -v ${JAVA_VERSION}`
+             fi
            fi
            if [ -z "$YJP_HOME" ]; then
              YJP_HOME=/Applications/YourKit.app

