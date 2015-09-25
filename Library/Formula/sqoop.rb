class Sqoop < Formula
  desc "Transfer bulk data between Hadoop and structured datastores"
  homepage "https://sqoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=sqoop/1.4.6/sqoop-1.4.6.bin__hadoop-2.0.4-alpha.tar.gz"
  version "1.4.6"
  sha256 "d582e7968c24ff040365ec49764531cb76dfa22c38add5f57a16a57e70d5d496"

  depends_on :java => "1.6+"
  depends_on "hadoop"
  depends_on "hbase"
  depends_on "hive"
  depends_on "zookeeper"
  depends_on "coreutils"

  # Patch for readlink -f missing on OS X. Should be fixed in 1.4.7.
  # https://issues.apache.org/jira/browse/SQOOP-2531
  patch :DATA

  def sqoop_envs
    <<-EOS.undent
      export HADOOP_HOME="#{HOMEBREW_PREFIX}"
      export HBASE_HOME="#{HOMEBREW_PREFIX}"
      export HIVE_HOME="#{HOMEBREW_PREFIX}"
      export ZOOCFGDIR="#{etc}/zookeeper"
    EOS
  end

  def install
    libexec.install %w[bin conf lib]
    libexec.install Dir["*.jar"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)

    # Install a sqoop-env.sh file
    envs = libexec/"conf/sqoop-env.sh"
    envs.write(sqoop_envs) unless envs.exist?
  end

  def caveats; <<-EOS.undent
    Hadoop, Hive, HBase and ZooKeeper must be installed and configured
    for Sqoop to work.
    EOS
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/sqoop version")
  end
end

__END__
diff --git a/bin/sqoop-codegen b/bin/sqoop-codegen
index 11a7ead..c24da32 100755
--- a/bin/sqoop-codegen
+++ b/bin/sqoop-codegen
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-create-hive-table b/bin/sqoop-create-hive-table
index 9380de4..316411a 100755
--- a/bin/sqoop-create-hive-table
+++ b/bin/sqoop-create-hive-table
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-eval b/bin/sqoop-eval
index a7b70c0..cc3f6a3 100755
--- a/bin/sqoop-eval
+++ b/bin/sqoop-eval
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-export b/bin/sqoop-export
index 3df45e3..4a3b3cf 100755
--- a/bin/sqoop-export
+++ b/bin/sqoop-export
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-help b/bin/sqoop-help
index ae4ee46..53ead16 100755
--- a/bin/sqoop-help
+++ b/bin/sqoop-help
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-import b/bin/sqoop-import
index d283395..21afee2 100755
--- a/bin/sqoop-import
+++ b/bin/sqoop-import
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-import-all-tables b/bin/sqoop-import-all-tables
index 8eb3fe4..4de0e31 100755
--- a/bin/sqoop-import-all-tables
+++ b/bin/sqoop-import-all-tables
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-import-mainframe b/bin/sqoop-import-mainframe
index 26a8c1e..ed74b84 100755
--- a/bin/sqoop-import-mainframe
+++ b/bin/sqoop-import-mainframe
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-job b/bin/sqoop-job
index 90d5772..fc817c3 100755
--- a/bin/sqoop-job
+++ b/bin/sqoop-job
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-list-databases b/bin/sqoop-list-databases
index 3428a3d..a373880 100755
--- a/bin/sqoop-list-databases
+++ b/bin/sqoop-list-databases
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-list-tables b/bin/sqoop-list-tables
index 393567c..0ab6849 100755
--- a/bin/sqoop-list-tables
+++ b/bin/sqoop-list-tables
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-merge b/bin/sqoop-merge
index e600e1f..e621917 100755
--- a/bin/sqoop-merge
+++ b/bin/sqoop-merge
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-metastore b/bin/sqoop-metastore
index 7c8a989..3448bcc 100755
--- a/bin/sqoop-metastore
+++ b/bin/sqoop-metastore
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`

diff --git a/bin/sqoop-version b/bin/sqoop-version
index d047309..db32c43 100755
--- a/bin/sqoop-version
+++ b/bin/sqoop-version
@@ -19,7 +19,81 @@
 # specific language governing permissions and limitations
 # under the License.

-prgm=`readlink -f $0`
+follow_one() {
+  # Resolve symlinks and relative path components along a path.  This requires
+  # its argument to be an absolute path.  This does not recursively re-resolve
+  # symlinks; if that is required, use the 'follow' method.
+
+  target=$1
+  OIFS=$IFS
+  IFS='/'
+
+  # Taking each dir component along the way, build up a new target directory,
+  # resolving '.', '..', and symlinks.
+  newtarget=''
+  for part in ${target}; do
+    if [ -z "${part}" ]; then
+      continue # Empty dir part. 'foo//bar'
+    elif [ "." == "${part}" ]; then
+      continue # Nothing special to do for '.'
+    elif  [ ".." == "${part}" ]; then
+      IFS=$OIFS
+      newtarget=`dirname ${newtarget}` # pop a component.
+    elif [ -h "${newtarget}/${part}" ]; then
+      IFS=$OIFS
+      link=`readlink ${newtarget}/${part}`
+      # links can be relative or absolute. Relative ones get appended to
+      # newtarget; absolute ones replace it.
+      if [ "${link:0:1}" != "/"  ]; then
+        newtarget="${newtarget}/${link}" # relative
+      else
+        newtarget="${link}" # absolute
+      fi
+    else # Regular file component.
+      newtarget="${newtarget}/${part}"
+    fi
+    IFS='/'
+  done
+
+  IFS=$OIFS
+  echo $newtarget
+}
+
+follow() {
+  # Portable 'readlink -f' function to follow a file's links to the final
+  # target.  Calls follow_one recursively til we're finished tracing symlinks.
+
+  target=$1
+  depth=$2
+
+  if [ -z "$depth" ]; then
+    depth=0
+  elif [ "$depth" == "1000" ]; then
+    # Don't recurse indefinitely; we've probably hit a symlink cycle.
+    # Just bail out here.
+    echo $target
+    return 1
+  fi
+
+  # Canonicalize the target to be an absolute path.
+  targetdir=`dirname ${target}`
+  targetdir=`cd ${targetdir} && pwd`
+  target=${targetdir}/`basename ${target}`
+
+  # Use follow_one to resolve links. Test that we get the same result twice,
+  # to terminate iteration.
+  first=`follow_one ${target}`
+  second=`follow_one ${first}`
+  if [ "${first}" == "${second}" ]; then
+    # We're done.
+    echo "${second}"
+  else
+    # Need to continue resolving links.
+    echo `follow ${second} $(( $depth + 1 ))`
+  fi
+}
+
+prgm=`follow $0`
 bin=`dirname ${prgm}`
 bin=`cd ${bin} && pwd`
