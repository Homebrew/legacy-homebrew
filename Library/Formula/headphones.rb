require 'formula'

class Headphones < Formula
  homepage 'https://github.com/rembo10/headphones'
  url 'https://github.com/rembo10/headphones/archive/v0.1.2.zip'
  sha1 'd02b4ba4b513e318abf08d72c5b8b9ed4e35de3a'

  head 'https://github.com/rembo10/headphones.git'

  depends_on 'Cheetah' => :python

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
        <string>#{opt_prefix}/bin/headphones</string>
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

  def startup_script; <<-EOS.undent
    #!/bin/bash
    python #{libexec}/Headphones.py --datadir=#{etc}/headphones $@
    EOS
  end

  def caveats
    "Headphones defaults to port 8181."
  end
end
