require 'formula'

class TerminalNotifier < Formula
  homepage 'https://github.com/alloy/terminal-notifier'
  url 'https://github.com/alloy/terminal-notifier/archive/1.6.1.tar.gz'
  sha1 '6270a811a9df97e3244ce9b9f33a89f7a87ba21f'

  head 'https://github.com/alloy/terminal-notifier.git'

  bottle do
    cellar :any
    sha1 "517d91093fc03ef3c263c39c49ed4357379ad3dd" => :mavericks
    sha1 "3267c5614f2759aeabe92d6ae287345993f03c25" => :mountain_lion
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
