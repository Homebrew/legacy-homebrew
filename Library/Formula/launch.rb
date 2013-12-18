require 'formula'

class Launch < Formula
  homepage 'http://web.sabi.net/nriley/software/'
  url 'http://web.sabi.net/nriley/software/launch-1.1.tar.gz'
  sha1 '000d6f1063f1b9091a8b10de90cfa778ed6a6ed1'

  head 'http://dev.sabi.net/svn/dev/trunk/launch/launch/', :using => :svn

  # Fix compilation on 10.8 and newer, per MacPorts
  def patches
    {:p0 => "https://trac.macports.org/export/114086/trunk/dports/aqua/launch/files/patch-main.c.diff"}
  end

  def install
    rm_rf "launch" # We'll build it ourself, thanks.
    system "#{ENV.cc} -o launch -std=c99 #{ENV.cflags} main.c -framework ApplicationServices"
    man1.install gzip('launch.1')
    bin.install 'launch'
  end
end
