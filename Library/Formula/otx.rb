require 'formula'

class Otx < Formula
  homepage 'http://otx.osxninja.com/'
  head 'http://otx.osxninja.com/builds/trunk/', :using => :svn

  depends_on :xcode # For working xcodebuild.

  def install
    system 'xcodebuild SYMROOT=build'
    build = buildpath/'build/Release'
    bin.install build+"otx"
    prefix.install build+"otx.app"
  end
end
