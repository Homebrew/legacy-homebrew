require 'formula'

class Pdnsrec < Formula
  homepage 'http://wiki.powerdns.com'
  url 'http://downloads.powerdns.com/releases/pdns-recursor-3.6.0.tar.bz2'
  sha256 '345651705f04eb63ef6ea4573587907bc213879834e37f4b7e4c2e70bc952372'

  depends_on :macos => :lion
  depends_on 'boost'
  depends_on 'lua' => :optional

  def install
    # Set overrides using environment variables
    ENV['DESTDIR'] = "#{prefix}"
    ENV['OPTFLAGS'] = "-O0"
    ENV.O0

    # Include Lua if requested
    if build.with? "lua"
      ENV['LUA'] = "1"
      ENV['LUA_CPPFLAGS_CONFIG'] = "-I#{Formula["lua"].opt_include}"
      ENV['LUA_LIBS_CONFIG'] = "-llua"
    end

    # Adjust hard coded paths in Makefile
    inreplace "Makefile", "/usr/sbin/", "#{sbin}/"
    inreplace "Makefile", "/usr/bin/", "#{bin}/"
    inreplace "Makefile", "/etc/powerdns/", "#{etc}/powerdns/"
    inreplace "Makefile", "/var/run/", "#{var}/run/"

    # Compile
    system "make basic_checks"
    system "make"

    # Do the install manually
    bin.install "rec_control"
    sbin.install "pdns_recursor"
    man1.install "pdns_recursor.1", "rec_control.1"

    # Generate a default configuration file
    (prefix/'etc/powerdns').mkpath
    system "#{sbin}/pdns_recursor --config > #{prefix}/etc/powerdns/recursor.conf"
  end
end
