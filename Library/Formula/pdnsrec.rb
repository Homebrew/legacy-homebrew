require "formula"

class Pdnsrec < Formula
  homepage "http://wiki.powerdns.com"
  url "http://downloads.powerdns.com/releases/pdns-recursor-3.7.2.tar.bz2"
  sha256 "1366bc1bed7c96fbd3926cf7a9e6d365c53b8a99182642debe1b2863dd015a7e"

  bottle do
    cellar :any
    sha1 "7c84aefdff297bdd00e2777c9dbb2215e0fdf377" => :yosemite
    sha1 "54f15f6c13ab46aed85caeadcb115dcc02abecbe" => :mavericks
    sha1 "1f90d87f999b6c0ff3f9fc847cc1b2e1373566fc" => :mountain_lion
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
    inreplace "Makefile.in", "/usr/sbin/", "#{sbin}/"
    inreplace "Makefile.in", "/usr/bin/", "#{bin}/"
    inreplace "Makefile.in", "/etc/powerdns/", "#{etc}/powerdns/"
    inreplace "Makefile.in", "/var/run/", "#{var}/run/"

    # Compile
    system "./configure"
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
