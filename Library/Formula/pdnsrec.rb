class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "http://wiki.powerdns.com"
  url "https://downloads.powerdns.com/releases/pdns-recursor-3.7.3.tar.bz2"
  sha256 "859ca6071147dd2e2ac1b2a5c3d5c2cbff0f5cbc501660db4259e7cbf27fea11"

  bottle do
    cellar :any
    sha256 "4b91cb394be8a7d768a1f1ea6cb3e4bd06fbfa6ea753948ad501eef78160b6e5" => :yosemite
    sha256 "629e0bb4b83c912ecdcd4543d248f0682d8c24f3da754b8f45b89547dd289fd9" => :mavericks
    sha256 "6ad788ccee069d9917096e800bda57cf8f0dd2577796cc056d9b05d82ae058fc" => :mountain_lion
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
