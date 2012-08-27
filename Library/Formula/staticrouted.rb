require 'formula'

class Staticrouted < Formula
  url 'http://alastairs-place.net/stuff/staticrouted.tar.bz2'
  homepage 'http://lists.apple.com/archives/macos-x-server/2010/Jul/msg00220.html'
  version '1.0.1'
  md5 '1f76b4f15d3bc332d40732bde154a20e'

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild SYMROOT=build -target Everything"
    sbin.install ["build/Release/staticroute", "build/Release/staticrouted"]
    man8.install ["staticroute.8", "staticrouted.8"]
    prefix.install "com.coriolis-systems.staticrouted.plist"
    (prefix+"com.coriolis-systems.staticrouted.plist").chmod 0644
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
      sudo mkdir -p /Library/LaunchDaemons
      sudo cp #{prefix}/com.coriolis-systems.staticrouted.plist /Library/LaunchDaemons/
      sudo launchctl load -w /Library/LaunchDaemons/com.coriolis-systems.staticrouted.plist

    If this is an upgrade and you already have the com.coriolis-systems.staticrouted.plist loaded:
      sudo launchctl unload -w /Library/LaunchDaemons/com.coriolis-systems.staticrouted.plist
      sudo cp #{prefix}/com.coriolis-systems.staticrouted.plist /Library/LaunchDaemons/
      sudo launchctl load -w /Library/LaunchDaemons/com.coriolis-systems.staticrouted.plist

    Or start it manually:
      sudo staticrouted
    EOS
  end
end
