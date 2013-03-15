require 'formula'

class Mogenerator < Formula
  homepage 'http://rentzsch.github.com/mogenerator/'
  url 'https://github.com/rentzsch/mogenerator/tarball/1.27'
  sha1 '49718d9f9633927dadbe665786a1d8d6e698dbf3'

  head 'https://github.com/rentzsch/mogenerator.git'

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
