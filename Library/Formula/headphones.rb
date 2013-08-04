require 'formula'

class Headphones < Formula
  homepage 'https://github.com/rembo10/headphones'
  url 'https://github.com/Banjer/headphones/archive/headphones.zip'
  sha1 '88f6bb6ac5a520870d4bef69b7578ca03f9b42c6'
  version '20130804'

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
    python "#{libexec}/Headphones.py"\
            "--datadir=#{etc}/headphones"\
           "$@"
    EOS
  end

  def caveats
    "Headphones defaults to port 8181."
  end
end
