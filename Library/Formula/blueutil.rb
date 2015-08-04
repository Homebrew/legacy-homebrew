class Blueutil < Formula
  desc "Get/set bluetooth power and discoverable state"
  homepage "https://github.com/toy/blueutil"
  url "https://github.com/toy/blueutil/archive/v1.0.0.tar.gz"
  sha256 "a433a96c0b85637b43d504efb3fd4411ba352149a17899c8536e01c738c8cb04"

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
