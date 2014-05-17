require 'formula'

class Headphones < Formula
  homepage 'https://github.com/rembo10/headphones'
  head 'https://github.com/rembo10/headphones.git'
  url 'https://github.com/rembo10/headphones/archive/v0.3.2.tar.gz'
  sha1 '61653a41af9d4aed61d1cd0efb9e4a56ae32451a'

  depends_on 'Cheetah' => :python

  def startup_script; <<-EOS.undent
    #!/bin/bash
    python "#{libexec}/Headphones.py" --datadir="#{etc}/headphones" "$@"
    EOS
  end

  def install
    libexec.install Dir['*']
    (bin+"headphones").write(startup_script)
  end

  plist_options :manual => 'headphones'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/$
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/headphones</string>
        <string>-q</string>
        <string>-d</string>
        <string>--nolaunch</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def caveats
    "Headphones defaults to port 8181."
  end
end
