require 'formula'

class Blueutil < Formula
  url 'git://github.com/toy/blueutil.git', :using => :git
  homepage 'https://github.com/toy/blueutil'
  version '1.0'

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    system 'xcodebuild', 'SDKROOT='
    bin.install 'build/Release/blueutil'
  end
end
