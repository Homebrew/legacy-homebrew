require 'formula'

class Automysqlbackup < Formula
  homepage 'http://sourceforge.net/projects/automysqlbackup/'
  url 'http://downloads.sourceforge.net/project/automysqlbackup/AutoMySQLBackup/AutoMySQLBackup%20VER%203.0/automysqlbackup-v3.0_rc6.tar.gz'
  version '3.0-rc6'
  sha1 'a21123a2c5fbf568a7fe167698a82697ae1cbb21'

  def install
    inreplace 'automysqlbackup' do |s|
      s.gsub! "/etc", etc
      s.gsub! "/var", var
    end
    inreplace 'automysqlbackup.conf' do |s|
      s.gsub! "/var", var
    end

    conf_path = (etc/'automysqlbackup')
    conf_path.install 'automysqlbackup.conf' unless (conf_path/'automysqlbackup.conf').exist?
    sbin.install 'automysqlbackup'
  end

  def caveats; <<-EOS.undent
    You will have to edit
      #{etc}/automysqlbackup/automysqlbackup.conf
    to set AutoMySQLBackup up to find your database and backup directory.

    The included plist file will run AutoMySQLBackup every day at 04:00.
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>OnDemand</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>StartCalendarInterval</key>
        <dict>
          <key>Hour</key>
          <integer>04</integer>
        </dict>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{sbin}/automysqlbackup</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
