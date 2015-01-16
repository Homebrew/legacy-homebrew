require "formula"

class ShadowsocksLibev < Formula
  homepage "https://github.com/shadowsocks/shadowsocks-libev"
  url "https://github.com/shadowsocks/shadowsocks-libev/archive/v1.6.2.tar.gz"
  sha1 "f0b3be37192f3e19a4bba167673b39f073ae14fa"

  bottle do
    sha1 "563ca02feeddc200c026b2b3d91a2924ff8654e3" => :yosemite
    sha1 "37bb5cf9d4f17f641cdee7a7c83091752d2e15a8" => :mavericks
    sha1 "af286b8542b1468428b13957313e2d36b1650b3d" => :mountain_lion
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
