require 'formula'

class Otx < Formula
  head 'http://otx.osxninja.com/builds/trunk/', :using => :svn
  homepage 'http://otx.osxninja.com/'

  def install
    system 'xcodebuild SYMROOT=build'
    build = Pathname.getwd + 'build/Release'
    bin.install build+"otx"
    prefix.install build+"otx.app"
  end
end
