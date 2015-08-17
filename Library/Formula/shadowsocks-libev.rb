class ShadowsocksLibev < Formula
  desc "Libev port of shadowsocks"
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.3.0.tar.gz"
  sha256 "e0a403cdbb20e2ad9934c9d20828265d4ab00f6a1fbaf4d52e9263b2a220f09f"
  head "https://github.com/shadowsocks/shadowsocks-libev.git"

  bottle do
    cellar :any
    revision 1
    sha256 "2cafe87a71ff1f7b512905d583431fec8f8ab9267e05df693989326d20308333" => :yosemite
    sha256 "cb164f15a12619af2e8c513b9a0665d911118dfacfe7d569fc94d0a67aace1de" => :mavericks
    sha256 "16df3679c44d2e723101d36dcb589ac414b235aa9e90a386faaa021345d06122" => :mountain_lion
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
