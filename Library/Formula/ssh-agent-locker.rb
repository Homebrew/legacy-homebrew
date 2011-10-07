require 'formula'

class SshAgentLocker < Formula
  url 'https://github.com/gdcbyers/ssh-agent-locker/tarball/master'
  homepage 'https://github.com/gdcbyers/ssh-agent-locker'
  md5 'e906b9a94f7a36611b11a7de4dbf91eb'
  version '1.0'

  def install
    system "xcodebuild SYMROOT=build"
    bin.install "build/Release/ssh-agent-locker"

    (prefix+'com.seaandco.geoff.ssh-agent-locker.plist').write startup_plist
    (prefix+'com.seaandco.geoff.ssh-agent-locker.plist').chmod 0644
  end

  def caveats
    s = <<-EOS
If this is your first install, automatically load on login with:
  mkdir -p ~/Library/LaunchAgents
  cp #{prefix}/com.seaandco.geoff.ssh-agent-locker.plist ~/Library/LaunchAgents/
  launchctl load -w ~/Library/LaunchAgents/com.seaandco.geoff.ssh-agent-locker.plist
    EOS

    s
  end

  def startup_plist
    <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.seaandco.geoff.ssh-agent-locker</string>
	<key>RunAtLoad</key>
	<true/>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/local/bin/ssh-agent-locker</string>
	</array>
</dict>
</plist>
    EOPLIST
  end
end
