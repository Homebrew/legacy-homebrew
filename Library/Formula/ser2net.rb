class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "http://ser2net.sourceforge.net"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-2.9.1.tar.gz"
  sha256 "fdee1e69903cf409bdc6f32403a566cbc6006aa9e2a4d6f8f12b90dfd5ca0d0e"

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace ["ser2net.c", "ser2net.8"], "/etc/ser2net.conf", "#{etc}/ser2net.conf"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
    etc.install "ser2net.conf"
  end

  def caveats; <<-EOS.undent
    To configure ser2net, edit the example configuration in #{etc}/ser2net.conf
    EOS
  end

  plist_options :manual => "ser2net -p 12345"

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
            <string>#{opt_sbin}/ser2net</string>
            <string>-p</string>
            <string>12345</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
