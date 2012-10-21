require 'formula'

class Mogenerator < Formula
  url 'https://github.com/rentzsch/mogenerator/tarball/1.26'
  homepage 'http://rentzsch.github.com/mogenerator/'
  sha1 '0ac8ad310760df366bdeeb32f9420548f3168ca4'
  head "https://github.com/rentzsch/mogenerator.git"

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
