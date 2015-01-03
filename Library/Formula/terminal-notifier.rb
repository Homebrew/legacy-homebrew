class TerminalNotifier < Formula
  homepage "https://github.com/alloy/terminal-notifier"
  url "https://github.com/alloy/terminal-notifier/archive/1.6.2.tar.gz"
  sha1 "ffd01b5a832e0167b9382c7ebec3e34349103b89"

  head "https://github.com/alloy/terminal-notifier.git"

  bottle do
    cellar :any
    sha1 "32a5d80adcf6c1e54ce7cc1ea282a12abc0cbf0f" => :yosemite
    sha1 "a4ea9dbf9e8260390f7ab7d9fc9471e95a6b3517" => :mavericks
    sha1 "f7ebd182b5a88663a1c98e64b77130c4508fc3f0" => :mountain_lion
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
    system "#{bin}/terminal-notifier", "-message", "Hello World!"
  end
end
