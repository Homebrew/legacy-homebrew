require "formula"

class ChromeCli < Formula
  homepage "https://github.com/prasmussen/chrome-cli"
  url "https://github.com/prasmussen/chrome-cli/archive/1.5.0.tar.gz"
  sha1 "aab28c1dfafd6a54f4de757b390bdb2b6ab0c522"

  head "https://github.com/prasmussen/chrome-cli.git"

  bottle do
    cellar :any
    revision 1
    sha1 "04f97a42bb938372e4b344b2c543575c2df61e87" => :mavericks
    sha1 "1ed37da928049461e239d848a77e3cc1838ee17a" => :mountain_lion
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
    system "#{bin}/chrome-cli", 'version'
  end
end
