require 'formula'

class Polipo < Formula
  homepage 'http://www.pps.jussieu.fr/~jch/software/polipo/'
  url 'http://www.pps.univ-paris-diderot.fr/~jch/software/files/polipo/polipo-1.1.1.tar.gz'
  sha1 'cf7461a96c4bf012496844d5a54171182c2cb1a7'

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
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/polipo</string>
        </array>
      </dict>
    </plist>
    EOS
  end
end
