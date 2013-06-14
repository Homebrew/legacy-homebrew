require 'formula'

class Wry < Formula
  homepage 'http://grailbox.com/wry/'
  url 'https://github.com/hoop33/wry/archive/v1.5.tar.gz'
  sha1 '56f03ff07b19b2b5489d024b60c1b1d23f347961'

  head 'https://github.com/hoop33/wry.git'

  depends_on :macos => :lion
  depends_on :xcode

  def install
    system 'xcodebuild -target wry -configuration Release SYMROOT=build OBJROOT=objroot'
    bin.install 'build/Release/wry'
  end
end
