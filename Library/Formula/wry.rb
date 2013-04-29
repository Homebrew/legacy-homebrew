require 'formula'

class NeedsLion < Requirement
  satisfy MacOS.version >= :lion

  def message
    "wry requires Mac OS X 10.7 or newer"
  end
end

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'https://github.com/hoop33/wry.git', :tag => 'v1.4'
  version '1.4'

  depends_on NeedsLion
  depends_on :xcode # For working xcodebuild.

  def install
    system 'xcodebuild -target wry -configuration Release SYMROOT=build OBJROOT=objroot'
    bin.install 'build/Release/wry'
  end
end

