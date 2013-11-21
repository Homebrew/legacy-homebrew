require 'formula'

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'https://github.com/hoop33/wry/archive/v1.6.tar.gz'
  sha1 '0032029d9a2716657f0dd7e0146d92ea5060ac42'

  head 'https://github.com/hoop33/wry.git'

  depends_on :macos => :lion
  depends_on :xcode

  def install
    system 'xcodebuild -target wry -configuration Release SYMROOT=build OBJROOT=objroot'
    bin.install 'build/Release/wry'
  end
end
