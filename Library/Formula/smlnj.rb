require 'formula'

class Smlnj < Formula
  homepage 'http://www.smlnj.org/'
  url 'http://smlnj.cs.uchicago.edu/dist/working/110.74/config.tgz'
  version '110.74'
  md5 '9c4f80eb53240b583eb96d8f8c556cf8'

  def targets
<<-EOS
request ml-ulex
request ml-ulex-mllex-tool
request ml-lex
request ml-lex-lex-ext
request ml-yacc
request ml-yacc-grm-ext
request ml-antlr
request ml-lpt-lib
request ml-burg
request smlnj-lib
request tdp-util
request cml
request cml-lib
request mlrisc
request ckit
request heap2asm
EOS
  end

  # fixes the install.sh script to use the correct SDK for Lion. See:
  # https://smlnj-gforge.cs.uchicago.edu/tracker/index.php?func=detail&aid=89&group_id=33&atid=215
  # https://github.com/mxcl/homebrew/issues/11370
  # https://github.com/mxcl/homebrew/pull/11443
  def patches
    DATA
  end

  def install
    ENV.deparallelize
    # smlnj is much easier to build if we do so in the directory where it
    # will be installed.  Thus, we're moving it to the prefix to be built
    # there.
    cd '..'
    libexec.install 'config'
    rm (libexec+'config/targets') # Rewrite targets list
    (libexec+'config/targets').write targets
    cd libexec
    system 'config/install.sh'
  end

  def caveats
    <<-EOS.undent
    This formula spews ML files all over lib, and puts hidden subfolders in bin.
    Because of this, we've installed it to:
      #{libexec}
    and we haven't linked it into #{HOMEBREW_PREFIX}

    You'll need to add:
      #{libexec}/bin
    to your PATH.

    Improvements are welcome.
    EOS
  end
end

__END__
diff --git a/install.sh b/install.sh
index ea5f8c3..0108774 100755
--- a/install.sh
+++ b/install.sh
@@ -290,6 +290,11 @@ case $ARCH in
 esac
 
 case $OPSYS in
+    darwin)
+    # finding the correct SDK
+    SDKVERSION=`/usr/bin/sw_vers -productVersion | grep -o ^[0-9][0-9]\.[0-9]`
+    EXTRA_DEFS="SDK=-isysroot /Developer/SDKs/MacOSX$SDKVERSION.sdk -mmacosx-version-min=$SDKVERSION"
+  ;;
     solaris)
 	MAKE=/usr/ccs/bin/make
 	;;
@@ -338,7 +343,7 @@ else
     "$CONFIGDIR"/unpack "$ROOT" runtime
     cd "$BASEDIR"/runtime/objs
     echo $this: Compiling the run-time system.
-    $MAKE -f mk.$ARCH-$OPSYS $EXTRA_DEFS
+    $MAKE -f mk.$ARCH-$OPSYS "$EXTRA_DEFS"
     if [ -x run.$ARCH-$OPSYS ]; then
 	mv run.$ARCH-$OPSYS "$RUNDIR"
 	if [ -f runx.$ARCH-$OPSYS ]; then
