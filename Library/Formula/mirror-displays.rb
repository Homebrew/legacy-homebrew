class MirrorDisplays < Formula
  desc "Toggle/set/query OSX display mirroring"
  homepage "https://github.com/fcanas/mirror-displays"
  url "https://github.com/fcanas/mirror-displays/archive/v1.1.tar.gz"
  sha256 "84d4de59da3cdb655d2b38d59fc0d38c89abf6f21acf1f8fc1bff4ab9f37fbee"
  head "https://github.com/fcanas/mirror-displays.git"

  depends_on :xcode => :build

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/mirror"
  end

  test do
    help_text = "Toggle mirroring (default behavior)"
    out = system "#{bin}/mirror -h"
    assert true, out.include?(help_text)
  end

end
