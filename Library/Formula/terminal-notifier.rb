require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/1.5.2.tar.gz'
  sha1 'af67729aa09c5673f70845299942e1fd250eb6ce'

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
