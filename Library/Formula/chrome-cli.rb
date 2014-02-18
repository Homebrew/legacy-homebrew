require "formula"

class ChromeCli < Formula
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.4.0.zip"
  sha1 "96b03d2e60d5998a8a549af95412253ad7337e7f"

  head "https://github.com/prasmussen/chrome-cli.git"

  depends_on :xcode

  def install
    system 'xcodebuild', 'SDKROOT=', 'SYMROOT=build'
    bin.install 'build/Release/chrome-cli'
  end
end
