require 'formula'

class Tor < Formula
  homepage 'https://www.torproject.org/'
  url 'https://www.torproject.org/dist/tor-0.2.4.21.tar.gz'
  sha1 'b93b66e4d5162cefc711cb44f9167ed4799ef990'
  revision 1

  bottle do
    sha1 "f03d0bf2f97e9520b4ea33c9a15112bdcec49768" => :mavericks
    sha1 "cc64556bfb03006f029472c2b4541065a174929e" => :mountain_lion
    sha1 "c612ec254314cf046c292df8416ddf0d8281c4ef" => :lion
  end

  devel do
    url 'https://www.torproject.org/dist/tor-0.2.5.3-alpha.tar.gz'
    version '0.2.5.3-alpha'
    sha1 '29784b3f711780cd60fff076f6deb9b1f633fe5c'
  end

  depends_on 'libevent'
  depends_on 'openssl'

  def install
    # Fix the path to the control cookie.
    inreplace \
      'contrib/tor-ctrl.sh',
      'TOR_COOKIE="/var/lib/tor/data/control_auth_cookie"',
      'TOR_COOKIE="$HOME/.tor/control_auth_cookie"'

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl-dir=#{Formula["openssl"].opt_prefix}"
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
            <string>#{opt_bin}/tor</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
