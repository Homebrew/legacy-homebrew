class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v1.0.0.tar.gz"
  sha1 "b1cce64f7fa87eb0cfa32ef8e1dfc1aa06dbbd98"

  head "https://github.com/toy/blueutil.git"

  bottle do
    cellar :any
    revision 1
    sha1 "179a9df22a362166d3e1ba8a902dfe34e126609d" => :yosemite
    sha1 "8fb356c326d1644cd31602d23dde6720ce844f27" => :mavericks
    sha1 "b267d3761cf1ac1415318c16b64332e44cdbaa2e" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/blueutil"
  end

  test do
    system "#{bin}/blueutil"
  end
end
