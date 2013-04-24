require 'formula'

class PerforceProxy < Formula
  homepage 'http://www.perforce.com/'

  if MacOS.prefer_64_bit?
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86_64/p4p'
    version '2012.2.572941-x86_64'
    sha1 '691fe24d3d01c213237e28974df7e21cdc901c1b'
  else
    url 'http://filehost.perforce.com/perforce/r12.2/bin.darwin90x86/p4p'
    version '2012.2.572941-x86'
    sha1 '2f662122e6aea27aab6684631635c741bd03f070'
  end

  def install
    sbin.install 'p4p'
    (var+"p4p").mkpath
  end

  def caveats; <<-EOS.undent
    To use the Perforce proxy to access your Perforce server, set your P4PORT
    environment variable to "localhost:1666".

    Before starting the proxy server, you probably need to edit the plist to use
    the correct host and port for your Perforce server (replacing the default
    perforce:1666).
    EOS
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
        <string>#{opt_prefix}/sbin/p4p</string>
        <string>-p</string>
        <string>1666</string>
        <string>-r</string>
        <string>#{var}/p4p</string>
        <string>-t</string>
        <string>perforce:1666</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}/p4p</string>
    </dict>
    </plist>
    EOS
  end
end
