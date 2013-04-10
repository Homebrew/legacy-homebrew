require 'formula'

class RiakCsControl < Formula
  homepage 'http://docs.basho.com/riakcs/latest/'

  if Hardware.is_64_bit? and not build.build_32_bit?
    url 'http://s3.amazonaws.com/downloads.basho.com/riak-cs-control/1.0/1.0.0/osx/10.6/riak-cs-control-1.0.0-OSX-x86_64.tar.gz'
    version '1.0.0-x86_64'
    sha256 '6853cfa571b12842d77e4e869165eb3a9414607cc7e7ac01dae41cb7886eae5b'
  else
    url 'http://s3.amazonaws.com/downloads.basho.com/riak-cs-control/1.0/1.0.0/osx/10.6/riak-cs-control-1.0.0-OSX-i386.tar.gz'
    version '1.0.0-i386'
    sha256 '2836febc73bfdb188f40d57e77dc2a000c6682b44048ffe208c40e66a1445428'
  end

  depends_on 'erlang'

  skip_clean 'libexec'

  # This patch provides proper environment lookups when using OSX
  def patches; DATA end

  def install
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/riak-cs-control", "version"
  end
end

__END__
diff -ruNP riak-cs-control-1.0.0/bin/riak-cs-control riak-cs-control-1.0.0-osx/bin/riak-cs-control
--- riak-cs-control-1.0.0/bin/riak-cs-control 2013-03-20 09:08:51.000000000 -0700
+++ riak-cs-control-1.0.0-osx/bin/riak-cs-control 2013-04-10 13:39:45.000000000 -0700
@@ -4,8 +4,26 @@

 # installed by node_package (github.com/basho/node_package)

+# Identify the script name
+SCRIPT=$(basename ${0})
+
 # Pull environment for this install
-. "$(cd ${0%/*} && pwd)/../lib/env.sh"
+RUNNER_SCRIPT=${0}
+
+if [ ! -L $RUNNER_SCRIPT ]; then
+    RUNNER_SCRIPT_DIR="$(dirname "${0}")"
+fi
+
+while [ -L $RUNNER_SCRIPT ]; do
+    RUNNER_BIN_DIR="$(dirname "$(readlink $RUNNER_SCRIPT)" )"
+    RUNNER_SCRIPT_DIR="$(cd $(dirname $RUNNER_SCRIPT) && cd $RUNNER_BIN_DIR && pwd)"
+    RUNNER_SCRIPT="$RUNNER_SCRIPT_DIR/$SCRIPT"
+done
+
+RUNNER_BASE_DIR=$(cd "$RUNNER_SCRIPT_DIR/.." && pwd)
+
+# Pull environment for this install
+. "$RUNNER_BASE_DIR/lib/env.sh"

 # Make sure the user running this script is the owner and/or su to that user
 check_user $@
@@ -17,12 +35,6 @@
 # Keep track of where script was invoked
 ORIGINAL_DIR=$(pwd)

-# Make sure CWD is set to runner run dir
-cd $RUNNER_BASE_DIR
-
-# Identify the script name
-SCRIPT=`basename $0`
-
 usage() {
     echo "Usage: $SCRIPT {start | stop| restart | reboot | ping | console | attach | "
     echo "                    ertspath | chkconfig | escript | version | getpid |"
@@ -53,11 +65,11 @@
         # Make sure log directory exists
         mkdir -p $RUNNER_LOG_DIR

-        HEART_COMMAND="$RUNNER_SCRIPT_DIR/$RUNNER_SCRIPT start"
+        HEART_COMMAND="$RUNNER_SCRIPT start"
         export HEART_COMMAND
         mkdir -p $PIPE_DIR
         $ERTS_PATH/run_erl -daemon $PIPE_DIR/ $RUNNER_LOG_DIR \
-            "exec $RUNNER_SCRIPT_DIR/$RUNNER_SCRIPT console" 2>&1
+            "exec $RUNNER_SCRIPT console" 2>&1

         if [ ! -z "$WAIT_FOR_PROCESS" ]; then
             # Wait for the node to come up. We can't just ping it because
@@ -175,7 +187,7 @@
         BINDIR=$RUNNER_BASE_DIR/erts-$ERTS_VSN/bin
         EMU=beam
         PROGNAME=`echo $0 | sed 's/.*\///'`
-        CMD="$BINDIR/erlexec -boot $RUNNER_BASE_DIR/releases/$APP_VSN/$RUNNER_SCRIPT \
+        CMD="$BINDIR/erlexec -boot $RUNNER_BASE_DIR/releases/$APP_VSN/$SCRIPT \
             -embedded -config $RUNNER_ETC_DIR/app.config \
             -pa $RUNNER_PATCH_DIR \
             -args_file $RUNNER_ETC_DIR/vm.args -- ${1+"$@"}"
diff -ruNP riak-cs-control-1.0.0/lib/env.sh riak-cs-control-1.0.0-osx/lib/env.sh
--- riak-cs-control-1.0.0/lib/env.sh  2013-03-20 09:08:52.000000000 -0700
+++ riak-cs-control-1.0.0-osx/lib/env.sh  2013-04-10 13:41:26.000000000 -0700
@@ -15,10 +15,16 @@
 fi
 unset POSIX_SHELL # clear it so if we invoke other scripts, they run as ksh as well

-RUNNER_SCRIPT_DIR=$(cd ${0%/*} && pwd)
-RUNNER_SCRIPT=${0##*/}
+# Pull environment for this install
+RUNNER_SCRIPT=${0}

-RUNNER_BASE_DIR=$(cd ${0%/*} && pwd)/..
+while [ -L $RUNNER_SCRIPT ]; do
+    RUNNER_BIN_DIR="$(dirname "$(readlink $RUNNER_SCRIPT)" )"
+    RUNNER_SCRIPT_DIR="$(cd $(dirname $RUNNER_SCRIPT) && cd $RUNNER_BIN_DIR && pwd)"
+    RUNNER_SCRIPT="$RUNNER_SCRIPT_DIR/$SCRIPT"
+done
+
+RUNNER_BASE_DIR=$(cd "$RUNNER_SCRIPT_DIR/.." && pwd)
 RUNNER_ETC_DIR=$RUNNER_BASE_DIR/etc
 RUNNER_LOG_DIR=$RUNNER_BASE_DIR/log
 RUNNER_LIB_DIR=$RUNNER_BASE_DIR/lib
@@ -99,7 +105,7 @@
             echoerr "sudo doesn't appear to be installed and your EUID isn't $RUNNER_USER" 1>&2
             exit 1
         fi
-        exec sudo -H -u $RUNNER_USER -i $RUNNER_SCRIPT_DIR/$RUNNER_SCRIPT $@
+        exec sudo -H -u $RUNNER_USER -i $RUNNER_SCRIPT $@
     fi
 }
