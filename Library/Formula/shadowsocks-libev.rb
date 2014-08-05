require "formula"

class ShadowsocksLibev < Formula
  homepage "https://github.com/madeye/shadowsocks-libev"
  url "https://github.com/madeye/shadowsocks-libev/archive/v1.4.6.tar.gz"
  sha1 "cccfd9866fa18d128801e66e621f7bd90e8589d3"

  bottle do
    revision 1
    sha1 "afe20437aec398c819eede05329982c4060729df" => :mavericks
    sha1 "e51d6e3409b25c583c9e0baa9039dbc84259a91b" => :mountain_lion
    sha1 "19b6e328cec37745a55dcc9569fe227bb908b464" => :lion
  end

  head "https://github.com/madeye/shadowsocks-libev.git"

  option "with-polarssl", "Use PolarSSL instead of OpenSSL"

  depends_on "libev"
  if build.with? "polarssl"
    depends_on "polarssl"
  else
    depends_on "openssl"
  end

  def install
    args = ["--prefix=#{prefix}"]

    if build.with? "polarssl"
      polarssl = Formula["polarssl"]

      args << "--with-crypto-library=polarssl"
      args << "--with-polarssl=#{polarssl.opt_prefix}"
    end

    system "./configure", *args
    system "make", "install"

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
