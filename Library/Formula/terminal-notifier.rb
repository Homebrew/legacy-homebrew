require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/1.6.0.tar.gz'
  sha1 '15517dfa070c7ad228424c0dcbb71774b699e99e'

  head 'https://github.com/alloy/terminal-notifier.git'

  depends_on :macos => :mountain_lion
  depends_on :xcode

  def install
    xcodebuild "-project", "Terminal Notifier.xcodeproj",
               "-target", "terminal-notifier",
               "SYMROOT=build",
               "-verbose"
    prefix.install Dir['build/Release/*']
    inner_binary = "#{prefix}/terminal-notifier.app/Contents/MacOS/terminal-notifier"
    bin.write_exec_script inner_binary
    chmod 0755, bin/'terminal-notifier'
  end
end
