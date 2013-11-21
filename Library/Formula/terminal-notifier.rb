require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/v1.5.1.tar.gz'
  sha1 'bc9805808f7b67f2871820f6a9ef45b0ec016ab9'

  head 'https://github.com/alloy/terminal-notifier.git'

  depends_on :macos => :mountain_lion
  depends_on :xcode

  def install
    system 'xcodebuild', "-project", "Terminal Notifier.xcodeproj",
                         "-target", "terminal-notifier",
                         "SYMROOT=build",
                         "-verbose"
    prefix.install Dir['build/Release/*']
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, bin/'terminal-notifier'
  end
end
