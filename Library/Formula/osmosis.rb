require 'formula'

class Osmosis < Formula
  url 'http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-0.39.zip'
  homepage 'http://wiki.openstreetmap.org/wiki/Osmosis'
  md5 'd3668ec3cf713246929de1b2f75eadef'

  def patches
    # need to adjust home dir for a clean install
    DATA
  end

  def install
    bin.install Dir['bin/osmosis']
    %w(lib config script).each { |d| libexec.install d }
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
