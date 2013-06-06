require 'formula'

class Blueutil < Formula
  homepage 'https://github.com/toy/blueutil'
  url 'https://github.com/toy/blueutil/archive/v1.0.0.tar.gz'
  sha1 'b1cce64f7fa87eb0cfa32ef8e1dfc1aa06dbbd98'

  head 'https://github.com/toy/blueutil.git'

  depends_on :xcode # For working xcodebuild.

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    system 'xcodebuild', 'SDKROOT=', 'SYMROOT=build'
    bin.install 'build/Release/blueutil'
  end
end
