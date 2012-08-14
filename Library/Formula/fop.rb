require 'formula'

class Fop < Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-1.0-bin.tar.gz"
  md5 "3186f93a314bdcb710bd7cb02d80404c"

  # Run in headless mode to avoid having it appear on the Dock and stealing UI focus.
  def patches
    DATA
  end

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      "#{libexec}/#{target}" "$@"
    EOS
  end

  def install
    libexec.install Dir["*"]
    (bin+'fop').write shim_script('fop')
  end
end


__END__
diff --git a/fop b/fop
index 3f2ac6f..c9167bb 100755
--- a/fop
+++ b/fop
@@ -19,6 +19,7 @@
 
 rpm_mode=true
 fop_exec_args=
+java_exec_args="-Djava.awt.headless=true"
 no_config=false
 fop_exec_debug=false
 show_help=false
@@ -247,7 +248,7 @@ fi
 
 # Execute FOP using eval/exec to preserve spaces in paths,
 # java options, and FOP args
-fop_exec_command="exec \"$JAVACMD\" $LOGCHOICE $LOGLEVEL -classpath \"$LOCALCLASSPATH\" $FOP_OPTS org.apache.fop.cli.Main $fop_exec_args"
+fop_exec_command="exec \"$JAVACMD\" $java_exec_args $LOGCHOICE $LOGLEVEL -classpath \"$LOCALCLASSPATH\" $FOP_OPTS org.apache.fop.cli.Main $fop_exec_args"
 if $fop_exec_debug ; then
     echo $fop_exec_command
 fi

