require 'formula'

class DatomicFree < Formula
  homepage ''
  url 'http://downloads.datomic.com/0.8.4122/datomic-free-0.8.4122.zip'
  sha1 '83d13aa53d6d2ab3d61efed02b233ed19f695b34'

  def install
    prefix.install Dir['*']

    inreplace "#{prefix}/config/samples/free-transactor-template.properties" do |s|
      s.gsub! /#data-dir=.*$/, "data-dir=#{var}/datomic"
      s.gsub! /#log-dir=.*$/, "log-dir=#{var}/log/datomic/"
    end

  end

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
            <string>bin/transactor</string>
            <string>#{prefix}/config/samples/free-transactor-template.properties</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>UserName</key>
          <string>#{ENV['USER']}</string>
          <key>WorkingDirectory</key>
          <string>#{prefix}</string>
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
        </dict>
      </plist>
    EOS
  end

end
