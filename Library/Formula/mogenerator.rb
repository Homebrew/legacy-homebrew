require 'formula'

class Mogenerator < Formula
  homepage 'http://rentzsch.github.io/mogenerator/'
  url 'https://github.com/rentzsch/mogenerator/archive/1.28.tar.gz'
  sha1 '2c92204c76cbe88091494d0730cf986efab8ef1a'

  head 'https://github.com/rentzsch/mogenerator.git'

  depends_on :xcode => :build

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release","SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
