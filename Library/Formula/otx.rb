require 'formula'

class Otx < Formula
  homepage 'http://otx.osxninja.com/'
  head 'http://otx.osxninja.com/builds/trunk/', :using => :svn

  depends_on :xcode # For working xcodebuild.

  def install
    inreplace 'otx.xcodeproj/project.pbxproj' do |s|
      s.gsub! "MacOSX10.6.sdk", "MacOSX#{MacOS.version}.sdk"
    end

    system 'xcodebuild SYMROOT=build'
    build = buildpath/'build/Release'
    bin.install build/"otx"
    prefix.install build/"otx.app"
  end
end
