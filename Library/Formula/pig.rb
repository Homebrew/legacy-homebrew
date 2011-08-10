require 'formula'

class Pig < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=pig/pig-0.9.0/pig-0.9.0.tar.gz'
  homepage 'http://pig.apache.org/'
  md5 '89e3bd3dbe3a9739ce54472421db6484'

  def patches
    DATA
  end

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install ['bin', "pig-#{version}-core.jar"]
  end
end

# There's something weird with Pig's launch script, it doesn't find the correct
# path. This patch removes a test that should fail, but doesn't.
__END__
diff --git a/bin/pig b/bin/pig
index 97fc649..79056cf 100644
--- a/bin/pig
+++ b/bin/pig
@@ -56,11 +56,7 @@ this="$0"
 while [ -h "$this" ]; do
     ls=`ls -ld "$this"`
     link=`expr "$ls" : '.*-> \(.*\)$'`
-    if expr "$link" : '.*/.*' > /dev/null; then
-        this="$link"
-    else
-        this=`dirname "$this"`/"$link"
-    fi
+    this=`dirname "$this"`/"$link"
 done

 # convert relative path to absolute path
