class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-3.7.3.tar.bz2"
  sha256 "859ca6071147dd2e2ac1b2a5c3d5c2cbff0f5cbc501660db4259e7cbf27fea11"

  bottle do
    cellar :any
    sha256 "68e80d6dd093d9ab1c986d9f68c97dfe9d8b46b228c4b27d64ce4bcd47105250" => :yosemite
    sha256 "afc4630468ea74d4a7aec183f5f5f3c4872b3bcca1aac7a58c9a579aa7d0cbcc" => :mavericks
    sha256 "a9faf9edf0e71de5e9ec9fa70d27811f353a8451b41746208fbdc0d592aa5910" => :mountain_lion
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
