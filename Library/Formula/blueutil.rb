require 'formula'

class Blueutil < Formula
  head 'https://github.com/toy/blueutil.git'
  homepage 'https://github.com/toy/blueutil'

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    system 'xcodebuild', 'SDKROOT='
    bin.install 'build/Release/blueutil'
  end
end
