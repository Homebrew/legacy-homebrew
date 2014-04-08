require "formula"

class ChromeCli < Formula
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.5.0.tar.gz"
  sha1 "aab28c1dfafd6a54f4de757b390bdb2b6ab0c522"

  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    cellar :any
    sha1 "d17df1c6d002dbf1009ed604d7affaa6a7c5cfbe" => :mavericks
    sha1 "4a657ecf95a174d57960538239f0920a285a7e39" => :mountain_lion
  end

  depends_on :xcode
  depends_on :macos => :mountain_lion

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install 'build/Release/chrome-cli'
  end

  test do
    system "#{bin}/chrome-cli", 'version'
  end
end
