class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "http://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/0.8.14.tar.gz"
  sha256 "2d579d9f403eb95064781ffb28aca2b258ca55d7a2ba056a8fa2b3e6b79721f2"

  bottle do
    sha1 "ab90e39f9669b929dd4ec43b9f736a1ab1cac652" => :mavericks
    sha1 "3b2c563f7316ed9c485744e24ec6abc3bb242040" => :mountain_lion
    sha1 "0c91986b55c0d35497ef0d4c42d992c9958c577e" => :lion
  end

  def install
    rm "setup.cfg"
    inreplace "setup.py" do |s|
      s.gsub! /\/etc/, etc
      s.gsub! /\/var/, var
    end

    # Replace hardcoded paths
    inreplace "fail2ban-client", "/usr/share/fail2ban", libexec
    inreplace "fail2ban-server", "/usr/share/fail2ban", libexec
    inreplace "fail2ban-regex", "/usr/share/fail2ban", libexec

    inreplace "fail2ban-client", "/etc", etc
    inreplace "fail2ban-regex", "/etc", etc

    inreplace "fail2ban-server", "/var", var
    inreplace "config/fail2ban.conf", "/var/run", (var/"run")

    inreplace "setup.py", "/usr/share/doc/fail2ban", (libexec/"doc")

    system "python", "setup.py", "install", "--prefix=#{prefix}", "--install-lib=#{libexec}"
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/fail2ban-client</string>
          <string>-x</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  def caveats
    <<-EOS.undent
      Before using Fail2Ban for the first time you should edit jail
      configuration and enable the jails that you want to use, for instance
      ssh-ipfw. Also make sure that they point to the correct configuration
      path. I.e. on Mountain Lion the sshd logfile should point to
      /var/log/system.log.

        * #{etc}/fail2ban/jail.conf

      The Fail2Ban wiki has two pages with instructions for MacOS X Server that
      describes how to set up the Jails for the standard MacOS X Server
      services for the respective releases.

        10.4: http://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.4)
        10.5: http://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.5)
    EOS
  end
end
