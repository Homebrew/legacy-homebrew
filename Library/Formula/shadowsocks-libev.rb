require "formula"

class ShadowsocksLibev < Formula
  homepage "https://github.com/madeye/shadowsocks-libev"
  url "https://github.com/madeye/shadowsocks-libev/archive/v1.5.3.tar.gz"
  sha1 "afb285b8d84bea44f4f844f00907f139c321b2e4"

  bottle do
    sha1 "5da303c6c410f9ec3f4d2e45185e185425486dda" => :yosemite
    sha1 "047fa26a91d4fff57b1ae1fba5b1e6d4a1b2d510" => :mavericks
    sha1 "4ce5dcb3983e4c336b75b89b2c66924275bca1c1" => :mountain_lion
  end

  head "https://github.com/madeye/shadowsocks-libev.git"

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

    inreplace "shadowsocks.8", "/etc/shadowsocks/config.json", "#{etc}/shadowsocks-libev.json"
    man8.install "shadowsocks.8"
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
