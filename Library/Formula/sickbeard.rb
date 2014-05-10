require 'formula'

class Sickbeard < Formula
  homepage 'http://www.sickbeard.com/'
  url 'https://github.com/midgetspy/Sick-Beard/archive/build-504.tar.gz'
  sha1 '0785a590a5028f10b3cbbee905e0834c52ac66c9'

  head 'https://github.com/midgetspy/Sick-Beard.git'

  depends_on 'Cheetah' => :python

  def install
    libexec.install Dir['*']
    (bin+"sickbeard").write(startup_script)
  end

  plist_options :manual => 'sickbeard'

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/sickbeard</string>
        <string>-q</string>
        <string>--nolaunch</string>
        <string>-p</string>
        <string>8081</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  def startup_script; <<-EOS.undent
    #!/bin/bash
    python "#{libexec}/SickBeard.py"\
           "--pidfile=#{var}/run/sickbeard.pid"\
           "--datadir=#{etc}/sickbeard"\
           "$@"
    EOS
  end

  def caveats
    "SickBeard defaults to port 8081."
  end
end
