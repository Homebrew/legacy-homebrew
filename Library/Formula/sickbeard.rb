require 'formula'

class Sickbeard < Formula
  homepage 'http://www.sickbeard.com/'
  url 'https://github.com/midgetspy/Sick-Beard/archive/build-498.tar.gz'
  sha1 'd4374c2377d4731aea3b142c4bd14fa82c832951'

  head 'https://github.com/midgetspy/Sick-Beard.git'

  depends_on 'Cheetah' => :python

  def install
    prefix.install Dir['*']
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
    SickBeard defaults to port 8081.
    EOS
  end
end
