require 'formula'

class Mogenerator < Formula
  url 'https://github.com/rentzsch/mogenerator/tarball/1.23'
  homepage 'http://rentzsch.github.com/mogenerator/'
  md5 'cb6bcbb1fe8303a89e8ee27b789ac8ed'
  head "https://github.com/rentzsch/mogenerator.git"

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
