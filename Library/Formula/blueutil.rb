require 'formula'

class Blueutil < Formula
  homepage 'https://github.com/toy/blueutil'
  url 'https://github.com/toy/blueutil/tarball/v1.0.0'
  sha1 '64df692f32e920590746ca9d7dc0ea19c3b5c909'

  head 'https://github.com/toy/blueutil.git'

  depends_on :xcode # For working xcodebuild.

  def install
    # Set to build with SDK=macosx10.6, but it doesn't actually need 10.6
    system 'xcodebuild', 'SDKROOT=', 'SYMROOT=build'
    bin.install 'build/Release/blueutil'
  end
end
