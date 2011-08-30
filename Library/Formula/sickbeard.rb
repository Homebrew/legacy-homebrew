require 'formula'

class Sickbeard < Formula
  url 'https://github.com/midgetspy/Sick-Beard/tarball/build-488'
  homepage 'http://www.sickbeard.com/'
  md5 '3bdcabe963e2622513f3cca2757fa2f0'

  head 'git://github.com/midgetspy/Sick-Beard.git'

  depends_on 'Cheetah' => :python

  def install
    prefix.install Dir['*']
    bin.mkpath
    (bin+"sickbeard").write(startup_script)
    (prefix+"com.sickbeard.sickbeard.plist").write(startup_plist)
  end

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>com.sickbeard.sickbeard</string>
      <key>ProgramArguments</key>
      <array>
           <string>#{bin}/sickbeard</string>
           <string>-q</string>
           <string>--nolaunch</string>
           <string>-p</string>
           <string>8081</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{`whoami`.chomp}</string>
    </dict>
    </plist>
    EOS
  end

  def startup_script; <<-EOS.undent
    #!/usr/bin/env ruby

    me = begin
      File.expand_path(
        File.join(
          File.dirname(__FILE__),
          File.readlink(__FILE__)
        )
      )
    rescue
      __FILE__
    end

    path = File.join(File.dirname(me), '..', 'SickBeard.py')
    args = ["--pidfile=#{var}/run/sickbeard.pid", "--datadir=#{etc}/sickbeard"]

    exec("python", path, *(args + ARGV))
    EOS
  end

  def caveats; <<-EOS.undent
    SickBeard will start up and launch http://localhost:8081/ when you run:

        sickbeard

    To launch automatically on startup, copy and paste the following into a terminal:

        mkdir -p ~/Library/LaunchAgents
        (launchctl unload -w ~/Library/LaunchAgents/com.sickbeard.sickbeard.plist 2>/dev/null || true)
        ln -sf #{prefix}/com.sickbeard.sickbeard.plist ~/Library/LaunchAgents/com.sickbeard.sickbeard.plist
        launchctl load -w ~/Library/LaunchAgents/com.sickbeard.sickbeard.plist

    You may want to edit:
      #{prefix}/com.sickbeard.sickbeard.plist
    to change the port (default: 8081) or user (default: #{`whoami`.chomp}).
    EOS
  end
end
