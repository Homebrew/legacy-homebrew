require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/1.6.0.tar.gz'
  sha1 '15517dfa070c7ad228424c0dcbb71774b699e99e'

  head 'https://github.com/alloy/terminal-notifier.git'

  bottle do
    cellar :any
    sha1 "a47abd03d3c9574af6f28e343f065b0393e37ed9" => :mavericks
    sha1 "063dfbda7818f78024f4d179a8037aa0bf99bc01" => :mountain_lion
  end

  depends_on :macos => :mountain_lion
  depends_on :xcode => :build

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
