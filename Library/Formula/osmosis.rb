class Osmosis < Formula
  desc "Command-line OpenStreetMap data processor"
  homepage "https://wiki.openstreetmap.org/wiki/Osmosis"
  url "http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-0.44.1.zip"
  sha256 "88ea076a9179d61736d3b943f39aa846bc4b52f3911eb09aaa02a72e9f4d44cb"

  bottle :unneeded

  # need to adjust home dir for a clean install
  patch :DATA

  def install
    bin.install "bin/osmosis"
    libexec.install %w[lib config script]
  end
end

__END__
--- a/bin/osmosis 2010-11-16 06:58:44.000000000 +0100
+++ b/bin/osmosis  2010-11-23 12:13:01.000000000 +0100
@@ -83,6 +83,7 @@
 saveddir=`pwd`
 MYAPP_HOME=`dirname "$PRG"`/..
 MYAPP_HOME=`cd "$MYAPP_HOME" && pwd`
+MYAPP_HOME="$MYAPP_HOME/libexec"
 cd "$saveddir"
 
 # Build up the classpath of required jar files via classworlds launcher.
