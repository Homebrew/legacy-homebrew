class ShadowsocksLibev < Formula
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v2.1.4.tar.gz"
  sha256 "d4e665e375224ba1d4844b97e7263491ce07a60f08c9cb55c3128a6d3aad13e7"

  bottle do
    sha256 "cb013262c8ed70fc267095522ab64882b28084bba47ff712f22fec04c02c569f" => :yosemite
    sha256 "4e4685f0d70746b662d5d634e00bc21f6690412e240810c9508234d2a65a68a9" => :mavericks
    sha256 "16de230fcfb8d3106e9fbfa2d84e94f67b2dcf104326cdb678321a5aeba7dc63" => :mountain_lion
  end

  head "https://github.com/shadowsocks/shadowsocks-libev.git"

  option "with-polarssl", "Use PolarSSL instead of OpenSSL"

  depends_on "polarssl" => :optional
  depends_on "openssl" if build.without? "polarssl"

  def install
    args = ["--prefix=#{prefix}"]

    if build.with? "polarssl"
      polarssl = Formula["polarssl"]

      args << "--with-crypto-library=polarssl"
      args << "--with-polarssl=#{polarssl.opt_prefix}"
    end

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
