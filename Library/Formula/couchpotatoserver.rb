require 'formula'

class Couchpotatoserver < Formula
  homepage 'https://couchpota.to'
  url 'https://github.com/RuudBurger/CouchPotatoServer/archive/build/2.0.6.1.tar.gz'
  sha1 '974669e0c5da2e003ba02703505796e4614ef510'

  head 'https://github.com/RuudBurger/CouchPotatoServer.git'

  def install
    prefix.install Dir['*']
    (bin+"couchpotatoserver").write(startup_script)
  end

  plist_options :manual => 'couchpotatoserver'

  def plist; <<-EOS.undent
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_prefix}/bin/couchpotatoserver</string>
        <key>ProgramArguments</key>
        <array>
          <string>--quiet</string>
          <string>--daemon</string>
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

    path = File.join(File.dirname(me), '..', 'CouchPotato.py')
    args = ["--pid_file=#{var}/run/couchpotatoserver.pid", "--data_dir=#{etc}/couchpotatoserver"]

    exec("python", path, *(args + ARGV))
    EOS
  end

  def caveats; <<-EOS.undent
    CouchPotatoServer defaults to port 5050.
    EOS
  end
end
