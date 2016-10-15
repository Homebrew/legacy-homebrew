require "formula"

class Duckdns < Formula
  homepage "http://jzelinskie.com/duckdns"
  url "https://github.com/jzelinskie/duckdns/archive/1.0.tar.gz"
  sha1 "93d8efd9e6862a678ce3a7b0e07d6ab19d8f9af6"

  def install
    bin.install "duckdns"
  end

  test do
    system "#{bin}/duckdns"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/duckdns</string>
      </array>
      <key>StartInterval</key>
      <integer>300</integer>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end

