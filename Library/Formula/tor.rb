require "formula"

class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.4.24.tar.gz"
  sha256 "99b15c6858c04e93a31d3ae90dd69f5021faa2237da93a24fbd246f4f1670ad1"

  bottle do
    sha1 "67271d2324c78f04e83408d408bb32024fbc5741" => :mavericks
    sha1 "e9400858212ed466b04d5ba6961f1d34475e00b1" => :mountain_lion
    sha1 "7c3084a1cd63f0547f5b41fb78c52ca0d635dae9" => :lion
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.2.5.8-rc.tar.gz"
    version "0.2.5.8-rc"
    sha256 "a4c04e049f8c5798991eb5028fb2831ea2353bf12c7f5afa9c1df1472787b22c"
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
