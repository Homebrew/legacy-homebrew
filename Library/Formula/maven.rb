require 'formula'

class Maven < Formula
  homepage 'http://maven.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz'
  sha1 'af0867027f0907631c1f85ecf668f74c08f5d5e9'

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
index 1f51748..2a208c9 100755
--- a/bin/mvn
+++ b/bin/mvn
@@ -54,6 +54,11 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   MINGW*) mingw=true;;
   Darwin*) darwin=true            
+           if [ -z "$JAVA_VERSION" ] ; then
+             JAVA_HOME=`/usr/libexec/java_home`
+           else
+             JAVA_HOME=`/usr/libexec/java_home -v ${JAVA_VERSION}`
+           fi
            #
            # Look for the Apple JDKs first to preserve the existing behaviour, and then look
            # for the new JDKs provided by Oracle.
@@ -187,4 +192,4 @@ exec "$JAVACMD" \
   -classpath "${M2_HOME}"/boot/plexus-classworlds-*.jar \
   "-Dclassworlds.conf=${M2_HOME}/bin/m2.conf" \
   "-Dmaven.home=${M2_HOME}"  \
-  ${CLASSWORLDS_LAUNCHER} "$@"
\ No newline at end of file
+  ${CLASSWORLDS_LAUNCHER} "$@"
diff --git a/bin/mvnDebug b/bin/mvnDebug
index fc829b1..cf95767 100755
--- a/bin/mvnDebug
+++ b/bin/mvnDebug
@@ -58,6 +58,11 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   MINGW*) mingw=true;;
   Darwin*) darwin=true 
+           if [ -z "$JAVA_VERSION" ] ; then
+             JAVA_HOME=`/usr/libexec/java_home`
+           else
+             JAVA_HOME=`/usr/libexec/java_home -v ${JAVA_VERSION}`
+           fi
            #
            # Look for the Apple JDKs first to preserve the existing behaviour, and then look
            # for the new JDKs provided by Oracle.
@@ -192,4 +197,4 @@ exec "$JAVACMD" \
   -classpath "${M2_HOME}"/boot/plexus-classworlds-*.jar \
   "-Dclassworlds.conf=${M2_HOME}/bin/m2.conf" \
   "-Dmaven.home=${M2_HOME}"  \
-  ${CLASSWORLDS_LAUNCHER} "$@"
\ No newline at end of file
+  ${CLASSWORLDS_LAUNCHER} "$@"
diff --git a/bin/mvnyjp b/bin/mvnyjp
index b3e8ac1..d76213e 100755
--- a/bin/mvnyjp
+++ b/bin/mvnyjp
@@ -62,6 +62,11 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   MINGW*) mingw=true;;
   Darwin*) darwin=true
+           if [ -z "$JAVA_VERSION" ] ; then
+             JAVA_HOME=`/usr/libexec/java_home`
+           else
+             JAVA_HOME=`/usr/libexec/java_home -v ${JAVA_VERSION}`
+           fi
            #
            # Look for the Apple JDKs first to preserve the existing behaviour, and then look
            # for the new JDKs provided by Oracle.
