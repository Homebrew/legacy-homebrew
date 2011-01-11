require 'formula'

class Mogenerator <Formula
  url 'https://github.com/rentzsch/mogenerator/tarball/1.21'
  homepage 'http://rentzsch.github.com/mogenerator/'
  md5 'bea004068e891e9ec96325c31cb182bf'
  head "git://github.com/rentzsch/mogenerator.git"

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
