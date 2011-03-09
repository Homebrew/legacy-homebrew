require 'formula'

class Whereami <Formula
  url 'https://github.com/yikulju/whereami/zipball/v1.0'
  homepage 'https://github.com/yikulju/whereami'
  md5 '8177912f98c7735b7a493a2ad511f2ff'
  version '1.0'

  def install
    system "xcodebuild -project whereami.xcodeproj"
    bin.install ['build/Release/whereami']
  end
end
