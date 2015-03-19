require 'formula'

class Vnstat < Formula
  homepage 'http://humdi.net/vnstat/'
  url 'http://humdi.net/vnstat/vnstat-1.13.tar.gz'
  sha256 '6f4e2599ebb195b25f499d3e2e865aa14da336dfc9cc03a79181aa71f7ed99cd'

  depends_on 'gd'

  def install
    inreplace "src/cfg.c", '/etc/vnstat.conf', "#{etc}/vnstat.conf"

    inreplace "man/vnstat.1" do |s|
      s.gsub! '/etc/vnstat.conf', "#{etc}/vnstat.conf"
      s.gsub! '/var/lib/vnstat', "#{var}/db/vnstat"
    end

    inreplace "man/vnstatd.1" do |s|
      s.gsub! '/etc/vnstat.conf', "#{etc}/vnstat.conf"
      s.gsub! '/var/lib/vnstat', "#{var}/db/vnstat"
      s.gsub! '/var/log/vnstat.log', "#{var}/log/vnstat/vnstat.log"
      s.gsub! '/var/run/vnstat.pid', "#{var}/run/vnstat/vnstat.pid"
    end

    inreplace "man/vnstati.1" do |s|
      s.gsub! '/etc/vnstat.conf', "#{etc}/vnstat.conf"
      s.gsub! '/var/lib/vnstat', "#{var}/db/vnstat"
    end

    inreplace "man/vnstat.conf.5", '/etc/vnstat.conf', "#{etc}/vnstat.conf"

    inreplace "cfg/vnstat.conf" do |c|
      c.gsub! 'Interface "eth0"', %Q{Interface "en0"}
      c.gsub! 'DatabaseDir "/var/lib/vnstat"', %Q{DatabaseDir "#{var}/db/vnstat"}
      c.gsub! 'LogFile "/var/log/vnstat/vnstat.log"', %Q{LogFile "#{var}/log/vnstat/vnstat.log"}
      c.gsub! 'PidFile "/var/run/vnstat/vnstat.pid"', %Q{PidFile "#{var}/run/vnstat/vnstat.pid"}
    end

    (var+'db/vnstat').mkpath

    system "make", "all", "-C", "src", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    (prefix+'etc').install "cfg/vnstat.conf"
    bin.install "src/vnstat", "src/vnstatd", "src/vnstati"
    man1.install "man/vnstat.1", "man/vnstatd.1", "man/vnstati.1"
    man5.install "man/vnstat.conf.5"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/vnstatd</string>
          <string>--nodaemon</string>
          <string>--config</string>
          <string>#{etc}/vnstat.conf</string>
        </array>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>GroupName</key>
        <string>staff</string>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>ProcessType</key>
        <string>Background</string>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    To monitor interfaces other than "en0" edit #{etc}/vnstat.conf
    EOS
  end
end
