require 'formula'

class Dnsmasq < Formula
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.57.tar.gz'
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  md5 'd10faeb409717eae94718d7716ca63a4'

  def options
    [['--with-idn', "Compile with IDN support"]]
  end

  depends_on "libidn" if ARGV.include? '--with-idn'

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"

    # Optional IDN support
    if ARGV.include? '--with-idn'
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if 10.7 <= MACOS_VERSION
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make install PREFIX=#{prefix}"

    prefix.install "dnsmasq.conf.example"
    (prefix + "uk.org.thekelleys.dnsmasq.plist").write startup_plist
    (prefix + "uk.org.thekelleys.dnsmasq.plist").chmod 0644
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
