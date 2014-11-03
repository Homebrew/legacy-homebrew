require "formula"

class Pdnsrec < Formula
  homepage "http://wiki.powerdns.com"
  url "http://downloads.powerdns.com/releases/pdns-recursor-3.6.2.tar.bz2"
  sha1 "69e461eb1da816f82c344137612d056f281217a1"
  revision 1

  bottle do
    cellar :any
    sha1 "b4e3d1a4132ff1c41972d3a8e0a70c945c6ad1ef" => :yosemite
    sha1 "19d5f92b26119931a0ea3b354b54870f3e3b10ae" => :mavericks
    sha1 "f391330c5b3211349ad4272d1823772b8f5a2300" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on "boost"
  depends_on "lua" => :optional

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
