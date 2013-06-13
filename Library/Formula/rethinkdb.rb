require 'formula'

class Rethinkdb < Formula
  homepage 'http://www.rethinkdb.com/'
  url 'http://download.rethinkdb.com/dist/rethinkdb-1.6.0.tgz'
  sha1 'f25044cf1540bc2d21514901172e9ab3d31b3342'

  depends_on 'boost' => :build
  depends_on 'v8'

  def install
    # Disable drivers because right now we don't build Python/Ruby bindings. Pull request welcome.
    system "./configure --prefix=#{prefix} --fetch protobuf --disable-drivers"
    system "make"
    system "make install-osx"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
          <string>#{opt_prefix}/bin/rethinkdb</string>
          <string>-d</string>
          <string>#{var}/rethinkdb</string>
          <string>--bind</string>
          <string>all</string>
          <string>--http-port</string>
          <string>8080</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/rethinkdb/rethinkdb.log</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
