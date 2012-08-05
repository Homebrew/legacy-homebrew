require 'formula'

class Sbt < Formula
  homepage 'http://www.scala-sbt.org/'
  url 'http://scalasbt.artifactoryonline.com/scalasbt/sbt-native-packages/org/scala-sbt/sbt/0.12.0/sbt.tgz'
  version '0.12.0'
  md5 'b167319b91b2c37031d8761b5b28fa76'

  def patches
    # add realpath, call it so we find the files in libexec
    # See https://github.com/sbt/sbt-launcher-package/issues/15
    DATA
  end

  def install
    libexec.install 'bin/sbt'
    libexec.install 'bin/sbt-launch-lib.bash'
    libexec.install 'bin/sbt-launch.jar'
    bin.install_symlink libexec+'sbt'
  end

end
__END__
diff --git a/bin/sbt b/bin/sbt
index a791e2a..d00cd1c 100755
--- a/bin/sbt
+++ b/bin/sbt
@@ -1,6 +1,10 @@
 #!/usr/bin/env bash
 
-. $(dirname $0)/sbt-launch-lib.bash
+realpath () {
+  python -c 'import os,sys;print os.path.realpath(sys.argv[1])' $1
+}
+
+. $(dirname $(realpath $0))/sbt-launch-lib.bash
 
 
 declare -r noshare_opts="-Dsbt.global.base=project/.sbtboot -Dsbt.boot.directory=project/.boot -Dsbt.ivy.home=project/.ivy"
diff --git a/bin/sbt-launch-lib.bash b/bin/sbt-launch-lib.bash
index 3bfd078..2fbf99b 100755
--- a/bin/sbt-launch-lib.bash
+++ b/bin/sbt-launch-lib.bash
@@ -29,7 +29,7 @@ dlog () {
 }
 
 jar_file () {
-  echo "$(dirname $0)/sbt-launch.jar"
+  echo "$(dirname $(realpath $0))/sbt-launch.jar"
 }
 
 acquire_sbt_jar () {
