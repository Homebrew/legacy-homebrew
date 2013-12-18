require 'formula'

class Tor < Formula
  homepage 'https://www.torproject.org/'
  url 'https://www.torproject.org/dist/tor-0.2.3.25.tar.gz'
  sha1 'ef02e5b0eb44ab1a5d6108c39bd4e28918de79dc'

  devel do
    url 'https://www.torproject.org/dist/tor-0.2.4.18-rc.tar.gz'
    version '0.2.4.18-rc'
    sha1 'cc12a8fdd62d4c1bd4ce37c8bf3bf830266b9e38'
  end

  option "with-brewed-openssl", "Build with Homebrew's OpenSSL instead of the system version"

  depends_on 'libevent'
  depends_on 'openssl' if build.with? 'brewed-openssl'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "-with-ssl=#{Formulary.factory('openssl').opt_prefix}" if build.with? 'brewed-openssl'

    system "./configure", *args
    system "make install"
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
