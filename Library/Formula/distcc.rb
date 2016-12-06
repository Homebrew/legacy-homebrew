require 'formula'

class Distcc < Formula
  homepage 'http://code.google.com/p/distcc/'
  url 'http://distcc.googlecode.com/files/distcc-3.2rc1.tar.gz'
  sha1 '7cd46fe0926a3a859a516274e6ae59fa8ba0262d'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def startup_plist
    return <<-EOPLIST
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
        <string>#{HOMEBREW_PREFIX}/bin/distccd</string>
        <string>--daemon</string>
        <string>--no-detach</string>
        <string>--allow=192.168.0.1/24</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end

  def caveats
    return <<-EOS.undent
      Use 'brew services start distcc' to start distccd automatically on login. By default, it will
      allow access to all clients on 192.168.0.1/24.
    EOS
  end

  def test
    system "distcc"
  end
end
