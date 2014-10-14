require "formula"

class RexsterConsole < Formula
  homepage "https://github.com/tinkerpop/rexster/wiki"
  url "http://tinkerpop.com/downloads/rexster/rexster-console-2.5.0.zip"
  sha1 "0243908c0ab65baea4b8092bb2b818c597622187"

  # Upstream in next release:
  # https://github.com/tinkerpop/rexster/commit/ac1d51c37b0bd7ccebd96e5605969b74a4ca1288
  patch :DATA

  def install
    libexec.install %w[lib doc]
    (libexec/"ext").mkpath
    (libexec/"bin").install "bin/rexster-console.sh" => "rexster-console"
    bin.install_symlink libexec/"bin/rexster-console"
  end

  test do
    system "#{bin}/rexster-console", "-h"
  end
end

__END__
diff --git a/bin/rexster-console.sh b/bin/rexster-console.sh
index 3fb2022..29554a5 100755
--- a/bin/rexster-console.sh
+++ b/bin/rexster-console.sh
@@ -1,8 +1,19 @@
 #!/bin/bash

-CP=$( echo `dirname $0`/../lib/*.jar . | sed 's/ /:/g')
-CP=$CP:$( echo `dirname $0`/../ext/*.jar . | sed 's/ /:/g')
-#echo $CP
+# From: http://stackoverflow.com/a/246128
+#   - To resolve finding the directory after symlinks
+SOURCE="${BASH_SOURCE[0]}"
+# resolve $SOURCE until the file is no longer a symlink
+while [ -h "$SOURCE" ]; do
+  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+  SOURCE="$(readlink "$SOURCE")"
+  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
+  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
+done
+DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
+
+CP=$( echo $DIR/../lib/*.jar . | sed 's/ /:/g')
+CP=$CP:$( echo $DIR/../ext/*.jar . | sed 's/ /:/g')

 # Find Java
 if [ "$JAVA_HOME" = "" ] ; then
