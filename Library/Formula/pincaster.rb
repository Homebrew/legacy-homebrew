require 'formula'

class Pincaster < Formula
  homepage 'https://github.com/jedisct1/Pincaster'
  url 'http://download.pureftpd.org/pincaster/releases/pincaster-0.6.tar.bz2'
  sha1 'ad3799ce3207480979355f30d6f534dad6229ae2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"

    inreplace "pincaster.conf" do |s|
      s.gsub! "/var/db/pincaster/pincaster.db", "#{var}/db/pincaster/pincaster.db"
      s.gsub! "# LogFileName       /tmp/pincaster.log", "LogFileName  #{var}/log/pincaster.log"
    end

    etc.install "pincaster.conf"
    (var+"db/pincaster/").mkpath
  end

  plist_options :manual => "pincaster #{HOMEBREW_PREFIX}/etc/pincaster.conf"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/pincaster</string>
          <string>#{etc}/pincaster.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pincaster.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pincaster.log</string>
      </dict>
    </plist>
    EOS
  end
end
