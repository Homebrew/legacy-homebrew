require 'formula'

class Whereami <Formula
  url 'git@github.com:yikulju/whereami.git', :using => :git
  homepage 'https://github.com/yikulju/whereami'
  md5 ''
  version '1.0'

  def install
    system "xcodebuild -project whereami.xcodeproj"
    bin.install ['build/Release/whereami']
  end
end
