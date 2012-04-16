require 'formula'

class Mogenerator < Formula
  url 'https://github.com/rentzsch/mogenerator/tarball/1.26'
  homepage 'http://rentzsch.github.com/mogenerator/'
  md5 'cc761752cc581188e1065bd0919ad4c3'
  head "https://github.com/rentzsch/mogenerator.git"

  def install
    system "xcodebuild -target mogenerator -configuration Release SYMROOT=symroot OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
