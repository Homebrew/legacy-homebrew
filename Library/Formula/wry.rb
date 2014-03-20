require 'formula'

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'https://github.com/hoop33/wry/archive/v1.7.2.tar.gz'
  sha1 '22ac510f0f83bcdc7432ec4fac8aabdf91685ec5'

  head 'https://github.com/hoop33/wry.git'

  depends_on :macos => :lion
  depends_on :xcode

  def install
    xcodebuild "-target", "wry", "-configuration", "Release", "SYMROOT=build", "OBJROOT=objroot"
    bin.install 'build/Release/wry'
  end
end
