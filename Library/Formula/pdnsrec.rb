require "formula"

class Pdnsrec < Formula
  homepage "http://wiki.powerdns.com"
  url "http://downloads.powerdns.com/releases/pdns-recursor-3.7.1.tar.bz2"
  sha1 "1651bb2ba4414c4276d18b281c0156576c37f741"

  bottle do
    cellar :any
    sha1 "7c84aefdff297bdd00e2777c9dbb2215e0fdf377" => :yosemite
    sha1 "54f15f6c13ab46aed85caeadcb115dcc02abecbe" => :mavericks
    sha1 "1f90d87f999b6c0ff3f9fc847cc1b2e1373566fc" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on "boost"
  depends_on "lua" => :optional

  # Upstream patch for bug in 3.7.1 release (will be in next release)
  # http://bert-hubert.blogspot.nl/2015/02/some-notes-on-sendmsg.html
  patch :p1 do
    url "https://gist.github.com/Habbie/107a297695dcac9efe9b/raw/78be11c907cf88ed41a725e97c8f5f1e2290309d/gistfile1.diff"
    sha1 "63140c8a38dc9593f72ad80af9d87ca80764aebd"
  end

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
