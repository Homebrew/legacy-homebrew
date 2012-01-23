require 'formula'

class Pig < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=pig/pig-0.9.1/pig-0.9.1.tar.gz'
  homepage 'http://pig.apache.org/'
  md5 'f9aef698536b67b2966e48d328caf071'

  def patches
    DATA
  end

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install ['bin', "pig-#{version}.jar"]
  end
end

# There's something weird with Pig's launch script, it doesn't find the correct
# path. This patch removes a test that should fail, but doesn't.
__END__
diff --git a/bin/pig b/bin/pig
index 97fc649..79056cf 100644
--- a/bin/pig
+++ b/bin/pig
@@ -61,6 +61,10 @@
 script="$(basename -- "$this")"
 this="$bin/$script"

+ls=`ls -ld "$this"`
+link=`expr "$ls" : '.*-> \(.*\)$'`
+this=`dirname "$this"`/"$link"
+
 # the root of the Pig installation
 export PIG_HOME=`dirname "$this"`/..
