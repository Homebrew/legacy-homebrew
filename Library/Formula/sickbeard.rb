require 'formula'

class Sickbeard < Formula
  homepage 'http://www.sickbeard.com/'
  url 'https://github.com/midgetspy/Sick-Beard/archive/build-498.tar.gz'
  sha1 'd4374c2377d4731aea3b142c4bd14fa82c832951'

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
        <string>#{opt_prefix}/bin/sickbeard</string>
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
           "--pid_file=#{var}/run/sickbeard.pid"\
           "--data_dir=#{etc}/sickbeard"\
           "$@"
    EOS
  end

  def caveats
    "SickBeard defaults to port 8081."
  end
end
