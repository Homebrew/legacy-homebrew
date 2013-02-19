require 'formula'

class Jsdoc3 < Formula
  homepage 'http://usejsdoc.org/'
  url 'https://github.com/jsdoc3/jsdoc/tarball/v3.0.1'
  sha1 '0c6ad2321d300a3eaa2e1d543f3fbf166ff1ce18'

  def patches
      DATA
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/'jsdoc'
  end
end
__END__
diff --git a/jsdoc b/jsdoc
index dd161e0..18cadfe 100755
--- a/jsdoc
+++ b/jsdoc
@@ -2,10 +2,11 @@
 
 # rhino discards the path to the current script file, so we must add it back
 SOURCE="$0"
-while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
-BASEDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+BASEDIR="$( dirname $SOURCE )"                                                      
+while [ -h "$SOURCE" ] ; do SOURCE="$(readlink $SOURCE)"; done                      
+BASEDIR="$( cd -P $BASEDIR/$( dirname $SOURCE ) && pwd )/../libexec"                
 
-if test $1 = "--debug"
+if test "$1" = "--debug"
 then
     echo "Running Debug"
     CMD="org.mozilla.javascript.tools.debugger.Main -debug"
@@ -15,7 +16,7 @@ else
 fi
 
 #Conditionally execute different command lines depending on whether we're running tests or not
-if test $1 = "-T"
+if test "$1" = "-T"
 then
     echo "Running Tests"
     java -classpath ${BASEDIR}/lib/js.jar ${CMD} -opt -1 -modules ${BASEDIR}/node_modules -modules ${BASEDIR}/rhino_modules -modules ${BASEDIR} ${BASEDIR}/jsdoc.js --dirname=${BASEDIR} $@
@@ -24,4 +25,4 @@ else
     java -classpath ${BASEDIR}/lib/js.jar ${CMD} -modules ${BASEDIR}/node_modules -modules ${BASEDIR}/rhino_modules -modules ${BASEDIR} ${BASEDIR}/jsdoc.js --dirname=${BASEDIR} $@
 fi
 
-#java -classpath ${BASEDIR}/lib/js.jar ${CMD} -modules ${BASEDIR}/node_modules -modules ${BASEDIR}/rhino_modules -modules ${BASEDIR} ${BASEDIR}/jsdoc.js --dirname=${BASEDIR} $@
\ No newline at end of file
+#java -classpath ${BASEDIR}/lib/js.jar ${CMD} -modules ${BASEDIR}/node_modules -modules ${BASEDIR}/rhino_modules -modules ${BASEDIR} ${BASEDIR}/jsdoc.js --dirname=${BASEDIR} $@

