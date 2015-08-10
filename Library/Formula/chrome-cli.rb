class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.5.0.tar.gz"
  sha256 "c53a391b112411adef70b7162d2af1ba420cc9975ba1886bc2cfe56793b5ef91"
  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    cellar :any
    revision 3
    sha256 "cc9183708695b487f989680ece10676dbfdecf7ec1c146fee10c98de4fdbc0d7" => :yosemite
    sha256 "d4a67b8432b254e6ce98d88abc9e31e1d1a67b4cf15fe75cec476fa4a45de8d5" => :mavericks
    sha256 "adec26d9c69c62a35aa6c42845f05f567ce5c6c5c170fb7defc315479d3531c1" => :mountain_lion
  end

  depends_on :xcode => :build
  depends_on :macos => :mountain_lion

  def install
    # Release builds
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli"

    # Canary builds; see:
    # https://github.com/prasmussen/chrome-cli/issues/15
    rm_rf "build"
    inreplace "chrome-cli/App.m", "com.google.Chrome", "com.google.Chrome.canary"
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli" => "chrome-canary-cli"

    # Chromium builds; see:
    # https://github.com/prasmussen/chrome-cli/issues/31
    rm_rf "build"
    inreplace "chrome-cli/App.m", "com.google.Chrome", "org.Chromium.chromium"
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli" => "chromium-cli"
  end

  test do
    system "#{bin}/chrome-cli", "version"
  end
end
