class TerminalNotifier < Formula
  desc "Send OS X User Notifications from the command-line"
  homepage "https://github.com/alloy/terminal-notifier"
  url "https://github.com/alloy/terminal-notifier/archive/1.6.3.tar.gz"
  sha256 "d71243e194d290e873eb5c5f30904e1d9406246d089e7d4d48ca275a8abfe275"

  head "https://github.com/alloy/terminal-notifier.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a71be6835b7612696fa22235edf1643ecb9722e4b4c4dff0cdd426cf42f9fc7" => :el_capitan
    sha256 "748aefaf06e506a51274395f600fff007d6dde927f0bc1911f3b83cc8e854928" => :yosemite
    sha256 "6609dfdb1840dfff23420a39220ba5e2eade7841b66ab167c3924c5be4f05248" => :mavericks
    sha256 "87e1ddf62740069b8fc35ae4c302f46ecb7c2c0cf32ff5ec8ffd6cdd9611e53e" => :mountain_lion
  end

  depends_on :macos => :mountain_lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose"
    prefix.install Dir["build/Release/*"]
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, bin/"terminal-notifier"
  end

  test do
    system "#{bin}/terminal-notifier", "-help" if MacOS.version < :yosemite
  end
end
