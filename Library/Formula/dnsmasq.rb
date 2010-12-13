require 'formula'

class Dnsmasq <Formula
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.55.tar.gz'
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  md5 'b093d7c6bc7f97ae6fd35d048529232a'

  def install
    ENV.deparallelize

    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"
    system "make install PREFIX=#{prefix}"

    prefix.install "dnsmasq.conf.example"
    (prefix + "uk.org.thekelleys.dnsmasq.plist").write startup_plist
  end

  def caveats; <<-EOS.undent
    To configure dnsmasq, copy the example configuration to #{etc}/dnsmasq.conf
    and edit to taste.

      cp #{prefix}/dnsmasq.conf.example #{etc}/dnsmasq.conf

    To load dnsmasq automatically on startup, install and load the provided launchd
    item as follows:

      sudo cp #{prefix}/uk.org.thekelleys.dnsmasq.plist /Library/LaunchDaemons
      sudo launchctl load -w /Library/LaunchDaemons/uk.org.thekelleys.dnsmasq.plist
    EOS
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>uk.org.thekelleys.dnsmasq</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/local/sbin/dnsmasq</string>
          <string>--keep-in-foreground</string>
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
