require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://unbound.net/downloads/unbound-1.4.22.tar.gz'
  sha1 'a56e31e2f3a2fefa3caaad9200dd943d174ca81e'

  bottle do
    sha1 "24b82835213927e67a4ad83c91e188b2b494c6d3" => :mavericks
    sha1 "84a921d4ad1ff56cd32c4062d1fb427443367527" => :mountain_lion
    sha1 "e426817cd99c1997803b6425269f4b0f2ffccbe8" => :lion
  end

  def install
    # gost requires OpenSSL >= 1.0.0
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gost"
    system "make install"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/unbound</string>
          <string>-d</string>
          <string>-c</string>
          <string>#{etc}/unbound/unbound.conf</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end
end
