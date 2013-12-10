require 'formula'

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'https://github.com/hoop33/wry/archive/v1.7.1.tar.gz'
  sha1 '5c015d98572f4e96a549f7da5637d5ff863a37d9'

  head 'https://github.com/hoop33/wry.git'

  depends_on :macos => :lion
  depends_on :xcode

  def install
    system 'xcodebuild -target wry -configuration Release SYMROOT=build OBJROOT=objroot'
    bin.install 'build/Release/wry'
  end
end
