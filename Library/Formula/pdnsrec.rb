require 'formula'

class Pdnsrec < Formula
  homepage 'http://wiki.powerdns.com'
  url 'http://downloads.powerdns.com/releases/pdns-recursor-3.5.3.tar.bz2'
  sha1 '1809003427b2e1b82e5bcaf55dfbaf02d7b1227a'

  depends_on :macos => :lion
  depends_on 'boost'
  depends_on 'lua' => :optional

  # Disable superenv, else the compiled binary crashes at startup
  env :std

  def install
    # Set overrides using environment variables
    ENV['DESTDIR'] = "#{prefix}"
    ENV['OPTFLAGS'] = "-O0"

    # Ensure only -O0 is passed to compiler
    ENV.remove_from_cflags /-Os/

    # Include Lua if requested
    if build.include? 'with-lua'
      ENV['LUA'] = "1"
      ENV['LUA_CPPFLAGS_CONFIG'] = "-I#{Formula.factory('lua').opt_prefix}/include"
      ENV['LUA_LIBS_CONFIG'] = "-llua"
    end

    # Add Homebrew prefix to config file location
    inreplace "config.h", "/etc/", "#{etc}/"

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
