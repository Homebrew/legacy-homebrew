require 'formula'

class Olsrd < Formula
  homepage 'http://www.olsr.org'
  url 'http://www.olsr.org/releases/0.6/olsrd-0.6.5.2.tar.bz2'
  sha1 '0a365dd5c70e44cd6a1da01ca6843b5e83c0bc58'

  def install
    lib.mkpath
    args = %W[
      DESTDIR=#{prefix}
      USRDIR=#{prefix}
      LIBDIR=#{lib}
    ]
    system 'make', 'build_all', *args
    system 'make', 'install_all', *args
  end

  plist_options :startup => true, :manual => "olsrd -f #{HOMEBREW_PREFIX}/etc/olsrd.conf"

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/sbin/olsrd</string>
          <string>-f</string>
          <string>#{etc}/olsrd.conf</string>
        </array>
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
