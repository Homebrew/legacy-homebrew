require "formula"

class ChromeCli < Formula
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.5.0.tar.gz"
  sha1 "aab28c1dfafd6a54f4de757b390bdb2b6ab0c522"

  head "https://github.com/prasmussen/chrome-cli.git"

  depends_on :xcode
  depends_on :macos => :mountain_lion # strange error with lion

  def install
    system 'xcodebuild', 'SDKROOT=', 'SYMROOT=build'
    bin.install 'build/Release/chrome-cli'
  end

  test do
    system "#{bin}/chrome-cli", 'version'
  end
end
