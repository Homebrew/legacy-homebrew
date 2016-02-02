class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.4.5.tar.gz"
  sha256 "08bf7f240ee39fa700aac636ca84b65f2f0cfbcfa63a0783afb05872940067e2"
  head "https://github.com/shadowsocks/shadowsocks-libev.git"

  bottle do
    cellar :any
    sha256 "889a2fe3ad6d38488d530945f56fa2251e6835897accc7d247c3680adf635b60" => :el_capitan
    sha256 "238726be00957112e1de5c875808f46f78f344cf5f7d89300c0301ea74dc3ac9" => :yosemite
    sha256 "dc30620a8f40a19b3e36a869c3d874d81ecf9886b682c06121bf21c162190400" => :mavericks
  end

  depends_on "openssl"

  def install
    args = ["--prefix=#{prefix}"]

    system "./configure", *args
    system "make"

    bin.install "src/ss-local", "src/ss-tunnel", "src/ss-server", "src/ss-manager"

    (buildpath/"shadowsocks-libev.json").write <<-EOS.undent
      {
          "server":"localhost",
          "server_port":8388,
          "local_port":1080,
          "password":"barfoo!",
          "timeout":600,
          "method":null
      }
    EOS
    etc.install "shadowsocks-libev.json"

    rm "man/ss-redir.1"
    inreplace Dir["man/*"], "/etc/shadowsocks-libev/config.json", "#{etc}/shadowsocks-libev.json"
    man8.install Dir["man/*.8"]
    man1.install Dir["man/*.1"]
  end

  test do
    (testpath/"shadowsocks-libev.json").write <<-EOS.undent
      {
          "server":"127.0.0.1",
          "server_port":9998,
          "local":"127.0.0.1",
          "local_port":9999,
          "password":"test",
          "timeout":600,
          "method":"table"
      }
    EOS
    server = fork { exec bin/"ss-server", "-c", testpath/"shadowsocks-libev.json" }
    client = fork { exec bin/"ss-local", "-c", testpath/"shadowsocks-libev.json" }
    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:9999", "github.com"
    ensure
      Process.kill 9, server
      Process.wait server
      Process.kill 9, client
      Process.wait client
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/shadowsocks-libev/bin/ss-local -c #{HOMEBREW_PREFIX}/etc/shadowsocks-libev.json"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/ss-local</string>
          <string>-c</string>
          <string>#{etc}/shadowsocks-libev.json</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
