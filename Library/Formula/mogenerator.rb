require 'formula'

class Mogenerator < Formula
  homepage 'http://rentzsch.github.com/mogenerator/'
  url 'https://github.com/rentzsch/mogenerator/tarball/1.27'
  sha1 '03b04a80d3ff1190736b72bf5ff5ce44d4670914'
  head 'https://github.com/rentzsch/mogenerator.git'

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
