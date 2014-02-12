require 'formula'

class Tor < Formula
  homepage 'https://www.torproject.org/'
  url 'https://www.torproject.org/dist/tor-0.2.4.20.tar.gz'
  sha1 '09ba4eda9a73c46852a277b721ed74c8263e8dba'

  devel do
    url 'https://www.torproject.org/dist/tor-0.2.5.1-alpha.tar.gz'
    version '0.2.5.1-alpha'
    sha1 'd10cb78e6a41657d970a1ce42105142bcfc315fb'
  end

  option "with-brewed-openssl", "Build with Homebrew's OpenSSL instead of the system version" if MacOS.version > :leopard

  depends_on 'libevent'
  depends_on 'openssl' if build.with?('brewed-openssl') || MacOS.version < :snow_leopard

  def install
    # Fix the path to the control cookie.
    inreplace \
      'contrib/tor-ctrl.sh',
      'TOR_COOKIE="/var/lib/tor/data/control_auth_cookie"',
      'TOR_COOKIE="$HOME/.tor/control_auth_cookie"'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "-with-ssl=#{Formulary.factory('openssl').opt_prefix}" if build.with?('brewed-openssl') || MacOS.version < :snow_leopard

    system "./configure", *args
    system "make install"

    bin.install "contrib/tor-ctrl.sh" => "tor-ctrl"
  end

  test do
    system "tor", "--version"
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
            <string>#{opt_prefix}/bin/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end

