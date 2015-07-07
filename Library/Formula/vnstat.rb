class Vnstat < Formula
  desc "Console-based network traffic monitor"
  homepage "http://humdi.net/vnstat/"
  url "http://humdi.net/vnstat/vnstat-1.14.tar.gz"
  sha256 "f8462a47d85d0890493dc9eaeafbc725ae631aa5b103fb7f8af4ddb2314e8386"

  head "https://github.com/vergoh/vnstat.git"

  bottle do
    cellar :any
    sha256 "e35e04ae895a0abdd11198ea4e313f4103c52b7f8e4356eb2b9d7dae8cebc254" => :yosemite
    sha256 "995fa5a0cba75a852526b9bfe5dde9ab1d5ff168e6298175e607d7bd6dc9f47e" => :mavericks
    sha256 "e1ad44a67cc8a6cb7cf5bb716473a42285226e0dca4f719f9e4d2be66f7f1e2b" => :mountain_lion
  end

  depends_on "gd"

  def install
    inreplace "src/cfg.c", "/etc/vnstat.conf", "#{etc}/vnstat.conf"

    inreplace "man/vnstat.1" do |s|
      s.gsub! "/etc/vnstat.conf", "#{etc}/vnstat.conf"
      s.gsub! "/var/lib/vnstat", "#{var}/db/vnstat"
    end

    inreplace "man/vnstatd.1" do |s|
      s.gsub! "/etc/vnstat.conf", "#{etc}/vnstat.conf"
      s.gsub! "/var/lib/vnstat", "#{var}/db/vnstat"
      s.gsub! "/var/log/vnstat.log", "#{var}/log/vnstat/vnstat.log"
      s.gsub! "/var/run/vnstat.pid", "#{var}/run/vnstat/vnstat.pid"
    end

    inreplace "man/vnstati.1" do |s|
      s.gsub! "/etc/vnstat.conf", "#{etc}/vnstat.conf"
      s.gsub! "/var/lib/vnstat", "#{var}/db/vnstat"
    end

    inreplace "man/vnstat.conf.5", "/etc/vnstat.conf", "#{etc}/vnstat.conf"

    inreplace "cfg/vnstat.conf" do |c|
      c.gsub! 'Interface "eth0"', %(Interface "en0")
      c.gsub! 'DatabaseDir "/var/lib/vnstat"', %(DatabaseDir "#{var}/db/vnstat")
      c.gsub! 'LogFile "/var/log/vnstat/vnstat.log"', %(LogFile "#{var}/log/vnstat/vnstat.log")
      c.gsub! 'PidFile "/var/run/vnstat/vnstat.pid"', %(PidFile "#{var}/run/vnstat/vnstat.pid")
    end

    (var+"db/vnstat").mkpath

    system "make", "all", "-C", "src", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    (prefix+"etc").install "cfg/vnstat.conf"
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

  test do
    begin
      stat = IO.popen("#{bin}/vnstatd --nodaemon --config #{etc}/vnstat.conf")
      sleep 1
    ensure
      Process.kill "SIGINT", stat.pid
      Process.wait stat.pid
    end
    assert_match "Info: Monitoring:", stat.read
  end
end
