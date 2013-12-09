require 'formula'

class Gremlin < Formula
  homepage 'http://gremlin.tinkerpop.com'
  url 'http://tinkerpop.com/downloads/gremlin/gremlin-groovy-2.4.0.zip'
  sha1 'ee7979e2a0a773a41ca998d81d3712193d5f5403'
  head 'https://github.com/tinkerpop/gremlin.git', :branch => 'master'
  depends_on "maven" => :build
  depends_on "coreutils"

  def patches
    DATA
  end

  def install
    if build.head?
      system 'mvn', 'clean', 'install'
    else
      bin.install 'bin/gremlin.sh' => 'gremlin'
      prefix.install 'data', 'doc'
      libexec.install Dir['lib/*']
    end
  end
end

__END__
diff --git a/bin/gremlin.sh b/bin/gremlin.sh
--- a/bin/gremlin.sh
+++ b/bin/gremlin.sh
@@ -5,7 +5,7 @@
     CP=$( echo `dirname $0`/../lib/*.jar . | sed 's/ /;/g')
     ;;
   *)
-    CP=$( echo `dirname $0`/../lib/*.jar . | sed 's/ /:/g')
+    CP=$( echo `dirname $(grealpath $0)`/../libexec/*.jar . | sed 's/ /:/g')
 esac
 #echo $CP
