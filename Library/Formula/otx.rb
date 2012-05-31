require 'formula'

class Otx < Formula
  homepage 'http://otx.osxninja.com/'
  head 'http://otx.osxninja.com/builds/trunk/', :using => :svn

  def install
    system 'xcodebuild SYMROOT=build'
    build = buildpath/'build/Release'
    bin.install build+"otx"
    prefix.install build+"otx.app"
  end
end
