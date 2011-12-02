require 'formula'

class Play < Formula
  url 'http://download.playframework.org/releases/play-1.2.3.zip'
  homepage 'http://www.playframework.org/'
  md5 '75822b1ec443239a4467147a94882442'
  head 'https://github.com/playframework/Play20.git', :branch => 'master'

  def install

    if ARGV.build_head?
      system "cd framework && ./build build-repository"
    else
      rm_rf 'python' # we don't need the bundled Python for windows
    end

    rm Dir['*.bat']
    libexec.install Dir['*']
    bin.mkpath
    ln_s libexec+'play', bin
  end

  def patches
    if ARGV.build_head?
      DATA
    end
  end
end

__END__
diff --git a/play b/play
index 0e6f55a..f39901b 100755
--- a/play
+++ b/play
@@ -1,18 +1,45 @@
 #! /usr/bin/env sh
 
+real_path () {
+  RESULT="$1"
+  while [ 1 = 1 ] 
+  do
+    DIRNAME=`dirname "$RESULT"`
+    LINK=`readlink "$RESULT"`
+    case "$LINK" in
+      "")
+        break
+        ;;
+      /*)
+        RESULT="$LINK"
+        ;;
+      *)
+        RESULT="$DIRNAME/$LINK"
+        ;;
+    esac
+  done
+
+  echo "$RESULT"
+}
+
+RP=`real_path $0`
+PLAY_HOME=`dirname "$RP"`
+
+echo "RP: $RP, $0"
+
 if [ -f conf/application.conf ]; then
   if test "$1" = "clean"; then
-    `dirname $0`/framework/cleanIvyCache
+    "$PLAY_HOME"/framework/cleanIvyCache
   fi
   if test "$1" = "stop"; then
     kill `cat RUNNING_PID`
     exit $?
   fi
   if [ -n "$1" ]; then
-    `dirname $0`/framework/build "$@"
+    "$PLAY_HOME"/framework/build "$@"
   else
-    `dirname $0`/framework/build play
+    "$PLAY_HOME"/framework/build play
   fi
 else
-  java -Dsbt.ivy.home=`dirname $0`/repository -Dplay.home=`dirname $0`/framework -Dsbt.boot.properties=`dirname $0`/framework/sbt/play.boot.properties -jar `dirname $0`/framework/sbt/sbt-launch-0.11.0.jar "$@"
+  java -Dsbt.ivy.home="$PLAY_HOME"/repository -Dplay.home="$PLAY_HOME"/framework -Dsbt.boot.properties="$PLAY_HOME"/framework/sbt/play.boot.properties -jar "$PLAY_HOME"/framework/sbt/sbt-launch-0.11.0.jar "$@"
 fi
