require "formula"

class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.4.22.tar.gz"
  sha1 "42349e02c3f6db4e6f2cc52b8a61ea91761ac4d6"

  bottle do
    revision 1
    sha1 "f6b42d12fb7dc5a18a6d58b3250923d0a0fcd78f" => :mavericks
    sha1 "f9225a57b8a494767cf4a5e126a5cbb19af86e7d" => :mountain_lion
    sha1 "5be6f9dd594330e1864f6a570873d86f3c84506f" => :lion
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.2.5.5-alpha.tar.gz"
    version "0.2.5.5-alpha"
    sha1 "fa4a685e6dceb78ddc0ad811d88e0831bf0ade2d"
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    if build.stable?
      # Fix the path to the control cookie. (tor-ctrl removed in v0.2.5.5.)
      inreplace "contrib/tor-ctrl.sh",
        'TOR_COOKIE="/var/lib/tor/data/control_auth_cookie"',
        'TOR_COOKIE="$HOME/.tor/control_auth_cookie"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make install"

    if build.stable?
      # (tor-ctrl removed in v0.2.5.5.)
      bin.install "contrib/tor-ctrl.sh" => "tor-ctrl"
    end
  end

  test do
    system bin/"tor", "--version"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
