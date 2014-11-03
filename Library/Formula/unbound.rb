require 'formula'

class Unbound < Formula
  homepage 'http://www.unbound.net'
  url 'http://unbound.net/downloads/unbound-1.4.22.tar.gz'
  sha1 'a56e31e2f3a2fefa3caaad9200dd943d174ca81e'

  bottle do
    revision 1
    sha1 "3138548421de83708c779650b874e311381db2bb" => :yosemite
    sha1 "b04af5da27520dd8a17094d52488d7e8d86b6f4e" => :mavericks
    sha1 "9b59edab1fe3f871058d3e7fe3eab54d3f013597" => :mountain_lion
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
