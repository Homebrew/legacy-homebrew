class Kwm < Formula
  desc "Tiling window manager with focus follows mouse for OSX."
  homepage "https://koekeishiya.github.io/kwm/"
  url "https://github.com/koekeishiya/kwm/archive/v1.0.0-RC2.tar.gz"
  version "1.0.0RC2"
  sha256 "61252c4710c189cd7f101a3f2555bfdfb2c58c0e32b7856b51bf4e0ba0579202"

  def install
    system "make", "install"
    bin.install "bin/kwm"
    bin.install "bin/kwmc"
    lib.install "bin/hotkeys.so"
    prefix.install "examples/kwmrc"
  end

  def plist; <<-EOF.undent
    <?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.koekeishiya.kwm</string>
    <key>ProgramArguments</key>
    <array>
      <string>#{bin}/kwm</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>Sockets</key>
    <dict>
        <key>Listeners</key>
        <dict>
            <key>SockServiceName</key>
            <string>3020</string>
            <key>SockType</key>
            <string>dgram</string>
            <key>SockFamily</key>
            <string>IPv4</string>
        </dict>
    </dict>

</dict>
</plist>
    EOF
  end

  def caveats; <<-EOF.undent
      Copy the example config from #{prefix}/kwmrc into your home directory.
        cp #{prefix}/kwmrc ~/.kwmrc
    EOF
  end

  test do
    system "#{bin}/kwm", "--version"
  end
end
