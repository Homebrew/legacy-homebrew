class Pincaster < Formula
  desc "Nosql database with a HTTP/JSON interface"
  homepage "https://github.com/jedisct1/Pincaster"
  url "https://download.pureftpd.org/pincaster/releases/pincaster-0.6.tar.bz2"
  sha256 "c88be055ecf357b50b965afe70b5fc15dff295fbe2b6f0c473cf7e4a795a9f97"
  revision 1

  bottle do
    cellar :any
    sha256 "7dc56017217e1080245e800b022a341dec65b4653fe6399dd97b1f3a9c7ba778" => :el_capitan
    sha256 "eacb8d4301eb15b9683f407f88aee5aea363a8b3b290c1cafd015a60cd202f73" => :yosemite
    sha256 "f1ba4aac8ac24e5aadcb2dc5e6192e50e00c267d765d5c2fdb1692b24a868a92" => :mavericks
  end

  depends_on "openssl"

  conflicts_with "libevent", :because => "Pincaster embeds libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-yajl=embedded"
    system "make", "install"

    inreplace "pincaster.conf" do |s|
      s.gsub! "/var/db/pincaster/pincaster.db", "#{var}/db/pincaster/pincaster.db"
      s.gsub! "# LogFileName       /tmp/pincaster.log", "LogFileName  #{var}/log/pincaster.log"
    end

    etc.install "pincaster.conf"
    (var/"db/pincaster/").mkpath
  end

  plist_options :manual => "pincaster #{HOMEBREW_PREFIX}/etc/pincaster.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pincaster</string>
          <string>#{etc}/pincaster.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pincaster.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pincaster.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    cp etc/"pincaster.conf", testpath
    inreplace "pincaster.conf", "/usr/local/var", testpath/"var"
    (testpath/"var/db/pincaster/").mkpath
    (testpath/"var/log").mkpath

    pid = fork do
      exec "#{bin}/pincaster pincaster.conf"
    end
    sleep 2

    begin
      assert_match /pong":"pong"/, shell_output("curl localhost:4269/api/1.0/system/ping.json")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
