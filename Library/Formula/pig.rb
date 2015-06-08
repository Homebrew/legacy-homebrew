class Pig < Formula
  desc "Platform for analyzing large data sets"
  homepage "https://pig.apache.org/"
  url "http://www.apache.org/dyn/closer.cgi?path=pig/pig-0.14.0/pig-0.14.0.tar.gz"
  mirror "https://archive.apache.org/dist/pig/pig-0.14.0/pig-0.14.0.tar.gz"
  sha256 "6aea66dda4791f82bad9654ec5290efc6179d333077b0ce9f07624c9c8b071a0"

  bottle do
    cellar :any
    sha1 "fce3bdc6c643263546405826d48cf991683ac3d9" => :yosemite
    sha1 "43cc11e90b60410a30946d919051d0fbda001605" => :mavericks
    sha1 "e0eac12c79628e4426de5e72645df0b175cc8a07" => :mountain_lion
  end

  depends_on :java

  patch :DATA

  def install
    (libexec/"bin").install "bin/pig"
    libexec.install ["pig-#{version}-core-h1.jar", "pig-#{version}-core-h2.jar", "lib"]
    (bin/"pig").write_env_script libexec/"bin/pig", Language::Java.java_home_env.merge(:PIG_HOME => libexec)
  end

  test do
    (testpath/"test.pig").write <<-EOS.undent
      sh echo "Hello World"
    EOS
    system bin/"pig", "-x", "local", "test.pig"
  end
end

# There's something weird with Pig's launch script, it doesn't find the correct
# path. This patch finds PIG_HOME from the pig binary path's symlink.
__END__
diff -u a/bin/pig b/bin/pig
--- a/bin/pig 2011-09-30 08:55:58.000000000 +1000
+++ b/bin/pig 2011-11-28 11:18:36.000000000 +1100
@@ -77,11 +77,8 @@

 # resolve links - $0 may be a softlink
 this="${BASH_SOURCE-$0}"
-
-# convert relative path to absolute path
-bin=$(cd -P -- "$(dirname -- "$this")">/dev/null && pwd -P)
-script="$(basename -- "$this")"
-this="$bin/$script"
+here=$(dirname $this)
+this="$here"/$(readlink $this)

 # the root of the Pig installation
 export PIG_HOME=`dirname "$this"`/..
