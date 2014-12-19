require "formula"

class ShadowsocksLibev < Formula
  homepage "https://github.com/madeye/shadowsocks-libev"
  url "https://github.com/madeye/shadowsocks-libev/archive/v1.6.1.tar.gz"
  sha1 "2cb88051e43c800dfe9ea55c8a2a3aee11d40ae2"

  bottle do
    sha1 "505df68f724008fb39b064763cb3d06ac0c9a0ee" => :yosemite
    sha1 "0fa41d7494b08853bbe93a6fdc59b5f9f2933807" => :mavericks
    sha1 "98ca1d724966abd78e1a44977598109b54c69e82" => :mountain_lion
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
