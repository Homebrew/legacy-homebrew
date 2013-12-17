require 'formula'

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'https://github.com/hoop33/wry/archive/v1.7.tar.gz'
  sha1 '474803f477d67c4afef634779c0e3bfb5a01d811'

  head 'https://github.com/hoop33/wry.git'

  depends_on :macos => :lion
  depends_on :xcode

  def install
    system 'xcodebuild -target wry -configuration Release SYMROOT=build OBJROOT=objroot'
    bin.install 'build/Release/wry'
  end
end
