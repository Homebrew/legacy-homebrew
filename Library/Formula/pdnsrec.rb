require "formula"

class Pdnsrec < Formula
  homepage "http://wiki.powerdns.com"
  url "http://downloads.powerdns.com/releases/pdns-recursor-3.6.1.tar.bz2"
  sha1 "b77befa0a20d9822523dec44c2559ffda4ea689d"
  revision 1

  bottle do
    cellar :any
    sha1 "e3e642cc9cda280a6e0d798efcd54fcc486c0ac2" => :mavericks
    sha1 "1e7f0e0eb7fc1cf8af80bb911a3f682fdb095199" => :mountain_lion
    sha1 "ea6dc4741847785620f6e48cc1f8205a880a85c2" => :lion
  end

  depends_on :macos => :lion
  depends_on "boost"
  depends_on "lua" => :optional

  # Temporary workaround for Mavericks
  # https://github.com/PowerDNS/pdns/issues/1707
  patch :DATA

  def install
    # Set overrides using environment variables
    ENV["DESTDIR"] = "#{prefix}"
    ENV["OPTFLAGS"] = "-O0"
    ENV.O0

    # Include Lua if requested
    if build.with? "lua"
      ENV["LUA"] = "1"
      ENV["LUA_CPPFLAGS_CONFIG"] = "-I#{Formula["lua"].opt_include}"
      ENV["LUA_LIBS_CONFIG"] = "-llua"
    end

    # Adjust hard coded paths in Makefile
    inreplace "Makefile", "/usr/sbin/", "#{sbin}/"
    inreplace "Makefile", "/usr/bin/", "#{bin}/"
    inreplace "Makefile", "/etc/powerdns/", "#{etc}/powerdns/"
    inreplace "Makefile", "/var/run/", "#{var}/run/"

    # Compile
    system "make", "basic_checks"
    system "make"

    # Do the install manually
    bin.install "rec_control"
    sbin.install "pdns_recursor"
    man1.install "pdns_recursor.1", "rec_control.1"

    # Generate a default configuration file
    (prefix/"etc/powerdns").mkpath
    system "#{sbin}/pdns_recursor --config > #{prefix}/etc/powerdns/recursor.conf"
  end
end

__END__
--- pdns-recursor-3.6.1/rec_channel.hh.orig 2014-09-09 09:33:33 UTC
+++ pdns-recursor-3.6.1/rec_channel.hh
@@ -4,6 +4,7 @@
 #include <map>
 #include <inttypes.h>
 #include <sys/un.h>
+#include <pthread.h>


 /** this class is used both to send and answer channel commands to the PowerDNS Recursor */
