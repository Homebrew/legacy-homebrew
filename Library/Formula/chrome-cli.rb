class ChromeCli < Formula
  desc "Control Google Chrome from the command-line"
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.5.0.tar.gz"
  sha256 "c53a391b112411adef70b7162d2af1ba420cc9975ba1886bc2cfe56793b5ef91"
  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    cellar :any
    revision 2
    sha256 "38d45913effcf3f48d14c5455e006aa99ec36f89ee38da8155a648826a60064f" => :yosemite
    sha256 "7cc270cf0c223b9dfa27c3498fa863e5309302fc6dbbc00f36c1c128904a9b5c" => :mavericks
    sha256 "329d94b79632a9750ec875bf6a401575d215f271c2f8f62fa88a0f01cb8e036c" => :mountain_lion
  end

  depends_on :xcode => :build
  depends_on :macos => :mountain_lion

  def install
    # Release builds
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli"

    # Canary builds; see:
    # https://github.com/prasmussen/chrome-cli/issues/15#issuecomment-35202217
    rm_rf "build"
    inreplace "chrome-cli/App.m", "com.google.Chrome", "com.google.Chrome.canary"
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/chrome-cli" => "chrome-canary-cli"
  end

  test do
    system "#{bin}/chrome-cli", "version"
  end
end
