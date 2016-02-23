class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.5.0.tar.gz"
  sha256 "c53a391b112411adef70b7162d2af1ba420cc9975ba1886bc2cfe56793b5ef91"
  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    cellar :any_skip_relocation
    revision 4
    sha256 "9bfb2379f8697da91606ea8b6e7c63240e6d20b184d5cdf72c4c7e63a959be16" => :el_capitan
    sha256 "05deec5813a4979652a645737a7ed7868878934f77ee5c4cc27140e11811b2d1" => :yosemite
    sha256 "4b40b52e047b6b8db966a75155d94d5c42d293c5b8058d1e887eb294e96129c9" => :mavericks
    sha256 "ccdfa38c03563f671508958ec1be43ef47fa368e3bb7c78743964a809409acba" => :mountain_lion
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
    inreplace "chrome-cli/App.m", "com.google.Chrome.canary", "org.Chromium.chromium"
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli" => "chromium-cli"
  end

  test do
    system "#{bin}/chrome-cli", "version"
  end
end
