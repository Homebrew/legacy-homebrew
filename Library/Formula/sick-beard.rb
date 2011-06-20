require 'formula'

class SickBeard < Formula
  url 'https://github.com/midgetspy/Sick-Beard/tarball/build-488'
  homepage 'http://www.sickbeard.com/'
  md5 '3bdcabe963e2622513f3cca2757fa2f0'

  head 'git://github.com/midgetspy/Sick-Beard.git'

  depends_on 'Cheetah' => :python

  def install
    bin.mkpath

    cp_r Dir['*'], prefix

    bin_path.write(bin_content)
    bin_path.chmod(0644)

    (prefix + startup_plist_name).write(startup_plist)
  end

  def startup_plist_name
    "com.sickbeard.sickbeard.plist"
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
           <string>#{bin}/sick-beard</string>
           <string>-q</string>
           <string>--nolaunch</string>
           <string>-p</string>
           <string>#{port}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>UserName</key>
      <string>#{whoami}</string>
    </dict>
    </plist>
    EOS
  end

  def bin_path
    bin + "sick-beard"
  end

  def bin_content; <<-EOS.undent
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
    args = ["--pidfile=/var/run/sickbeard.pid", "--datadir=#{data_dir}"]

    exec("python", path, *(args + ARGV))
    EOS
  end

  def data_dir
    (etc + 'sickbeard')
  end

  def port
    8081
  end

  def whoami
    `whoami`.chomp
  end

  def caveats; <<-EOS.undent
    SickBeard will start up and launch http://localhost:#{port}/ when you run:

        sick-beard

    To launch automatically on startup, copy and paste the following into a terminal:

        mkdir -p ~/Library/LaunchAgents
        (launchctl unload -w ~/Library/LaunchAgents/#{startup_plist_name} 2>/dev/null || true)
        ln -sf #{prefix}/#{startup_plist_name} ~/Library/LaunchAgents/#{startup_plist_name}
        launchctl load -w ~/Library/LaunchAgents/#{startup_plist_name}

    You may want to edit #{prefix}/#{startup_plist_name} to change
    the port (default: #{port}) or user (default: #{whoami}).
    EOS
  end
end
