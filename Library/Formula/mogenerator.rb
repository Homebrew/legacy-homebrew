require 'formula'

class Mogenerator < Formula
  homepage 'http://rentzsch.github.io/mogenerator/'
  url 'https://github.com/rentzsch/mogenerator/archive/1.27.tar.gz'
  sha1 'd9defaa6352624cacbe8640aa82af8e14de74848'

  head 'https://github.com/rentzsch/mogenerator.git'

  depends_on :xcode

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
