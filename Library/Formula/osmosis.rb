class Osmosis < Formula
  desc "Command-line OpenStreetMap data processor"
  homepage "http://wiki.openstreetmap.org/wiki/Osmosis"
  url "http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-0.43-RELEASE.zip"
  sha256 "c891fe095b7f960f575cb39d9794c67cc7df9f4c665d2dda88dfb57b770f0bbe"

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
