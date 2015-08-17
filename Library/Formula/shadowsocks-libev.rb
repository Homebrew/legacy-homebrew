class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.3.0.tar.gz"
  sha256 "e0a403cdbb20e2ad9934c9d20828265d4ab00f6a1fbaf4d52e9263b2a220f09f"
  head "https://github.com/shadowsocks/shadowsocks-libev.git"

  bottle do
    cellar :any
    sha256 "a788de5728e0348180f380f040782fbbf5ef4f8593594b51a4e8029aa7c57b3a" => :yosemite
    sha256 "ff062a629b1d83d3c46d5152ad9f6795ff9ddc71d847fe207f25a15ad8176e47" => :mavericks
    sha256 "8d38c5e7569675c2f963d7659a81ddb52ea5ee4091d1b8a9af8d689f6fcce438" => :mountain_lion
  end

  depends_on "openssl"

  def install
    args = ["--prefix=#{prefix}"]

    system "./configure", *args
    system "make"

    bin.install "src/ss-local"
    bin.install "src/ss-tunnel"

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

    inreplace "shadowsocks-libev.8", "/etc/shadowsocks-libev/config.json", "#{etc}/shadowsocks-libev.json"
    man8.install "shadowsocks-libev.8"
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
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
