require 'formula'

class Pig < Formula
  url 'http://apache.dataphone.se/hadoop/pig/pig-0.5.0/pig-0.5.0.tar.gz'
  homepage 'http://hadoop.apache.org/pig/'
  md5 '9687f3a8c6042938bf8b1b225e6d4b40'

  def patches
    DATA
  end

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install ['bin', 'lib/hadoop20.jar', "pig-#{version}-core.jar"]
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
