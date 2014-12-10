require 'formula'

class Fop < Formula
  homepage "http://xmlgraphics.apache.org/fop/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=/xmlgraphics/fop/binaries/fop-1.1-bin.tar.gz"
  sha1 '6b96c3f3fd5efe9f2b6b54bfa96161ec3f6a1dbc'

  # http://offo.sourceforge.net/hyphenation/
  resource 'hyph' do
    url 'https://downloads.sourceforge.net/project/offo/offo-hyphenation-utf8/0.1/offo-hyphenation-fop-stable-utf8.zip'
    sha1 'c2a3f6e985b21c9702a714942ac747864c8b1759'
  end

  # fixes broken default java path as in
  # http://svn.apache.org/viewvc/ant/core/trunk/src/script/ant?r1=1238725&r2=1434680&pathrev=1434680&view=patch
  patch :DATA

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/'fop'
    resource('hyph').stage do
      (libexec/'build').install 'fop-hyph.jar'
    end
  end
end

__END__
diff --git a/fop b/fop
index aca642b..1cae344 100755
--- a/fop
+++ b/fop
@@ -81,7 +81,11 @@ case "`uname`" in
   CYGWIN*) cygwin=true ;;
   Darwin*) darwin=true
            if [ -z "$JAVA_HOME" ] ; then
-             JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
+               if [ -x '/usr/libexec/java_home' ] ; then
+                   JAVA_HOME=`/usr/libexec/java_home`
+               elif [ -d "/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home" ]; then
+                   JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
+               fi
            fi
            ;;
 esac
