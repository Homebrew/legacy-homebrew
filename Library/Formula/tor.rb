require "formula"

class Tor < Formula
  homepage "https://www.torproject.org/"
  url "https://www.torproject.org/dist/tor-0.2.4.22.tar.gz"
  sha1 "42349e02c3f6db4e6f2cc52b8a61ea91761ac4d6"

  bottle do
    sha1 "db30a93edec642fda6226e605371659304da00fa" => :mavericks
    sha1 "91e947a4b9beace522311322696fd6e5ac3519e1" => :mountain_lion
    sha1 "b48d094d36aaf0e2a245067f380c4ce517ba645e" => :lion
  end

  devel do
    url "https://www.torproject.org/dist/tor-0.2.5.4-alpha.tar.gz"
    version "0.2.5.4-alpha"
    sha1 "6817c103e2e401330823930e1a0dec38e5147ba2"
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    # Fix the path to the control cookie.
    inreplace "contrib/tor-ctrl.sh",
      'TOR_COOKIE="/var/lib/tor/data/control_auth_cookie"',
      'TOR_COOKIE="$HOME/.tor/control_auth_cookie"'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-openssl-dir=#{Formula["openssl"].opt_prefix}"
    system "make install"

    bin.install "contrib/tor-ctrl.sh" => "tor-ctrl"
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
