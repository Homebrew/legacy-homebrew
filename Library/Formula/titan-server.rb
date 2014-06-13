require "formula"

class TitanServer < Formula
  homepage "https://thinkaurelius.github.io/titan/"
  url "http://s3.thinkaurelius.com/downloads/titan/titan-server-0.4.4.zip"
  sha1 "549f14f372fb94bf567a34f7e1bcc650addfee8a"

  patch :DATA

  def install
    libexec.install %w[bin conf doc ext lib log rexhome]
    bin.install_symlink libexec/"bin/titan.sh" => "titan"
    bin.install_symlink libexec/"bin/rexster-console.sh" => "titan-rexster-console"
  end

  test do
    system "false"
  end
end

__END__
diff --git a/bin/rexster-console.sh b/bin/rexster-console.sh
index dabc213..145085c 100755
--- a/bin/rexster-console.sh
+++ b/bin/rexster-console.sh
@@ -1,7 +1,13 @@
 #!/bin/bash
 
 set_unix_paths() {
-    BIN="$(dirname $0)"
+    SOURCE="${BASH_SOURCE[0]}"
+    while [ -h "$SOURCE" ]; do
+        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+        SOURCE="$(readlink "$SOURCE")"
+        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+    done
+    BIN="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
     CP="$(echo $BIN/../conf $BIN/../lib/*.jar . | tr ' ' ':')"
     CP="$CP:$(find -L $BIN/../ext/ -name "*.jar" | tr '\n' ':')"
 }
diff --git a/bin/titan.sh b/bin/titan.sh
index 0ea74c9..a78c48b 100755
--- a/bin/titan.sh
+++ b/bin/titan.sh
@@ -1,6 +1,12 @@
 #!/bin/bash
 
-BIN="`dirname $0`"
+SOURCE="${BASH_SOURCE[0]}"
+while [ -h "$SOURCE" ]; do
+  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+  SOURCE="$(readlink "$SOURCE")"
+  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+done
+BIN="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
 REXSTER_CONFIG_TAG=cassandra-es
 : ${CASSANDRA_STARTUP_TIMEOUT_S:=60}
 : ${REXSTER_SHUTDOWN_TIMEOUT_S:=60}
