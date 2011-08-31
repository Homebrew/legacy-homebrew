require 'formula'

class Mogenerator < Formula
  url 'https://github.com/rentzsch/mogenerator/tarball/1.22'
  homepage 'http://rentzsch.github.com/mogenerator/'
  md5 '72084ea17995f3ef9faa1ce9379a5ca3'
  head "https://github.com/rentzsch/mogenerator.git"

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
