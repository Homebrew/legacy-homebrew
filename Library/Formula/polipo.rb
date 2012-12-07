require 'formula'

class Polipo < Formula
  homepage 'http://www.pps.jussieu.fr/~jch/software/polipo/'
  url 'http://freehaven.net/~chrisd/polipo/polipo-1.0.4.1.tar.gz'
  sha1 'e755b585a9bba2b599a6bcc7c6f7035d3cb27bec'

  head 'git://git.wifi.pps.jussieu.fr/polipo'

  def install
    cache_root = (var + "cache/polipo")
    cache_root.mkpath
    args = %W[PREFIX=#{prefix}
              LOCAL_ROOT=#{share}/polipo/www
              DISK_CACHE_ROOT=#{cache_root}
              MANDIR=#{man}
              INFODIR=#{info}
              PLATFORM_DEFINES=-DHAVE_IPv6]

    system "make", "all", *args
    system "make", "install", *args
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/polipo</string>
        </array>
      </dict>
    </plist>
    EOS
  end
end
