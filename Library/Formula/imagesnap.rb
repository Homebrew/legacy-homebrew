require 'formula'

class Imagesnap < Formula
  url 'http://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz'
  homepage 'http://iharder.sourceforge.net/current/macosx/imagesnap/'
  md5 '32e341f059a91703816d8aa9b87fb1e4'

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild -project ImageSnap.xcodeproj SYMROOT=build -sdk macosx#{MACOS_VERSION}"
    bin.install "build/Release/imagesnap"
  end
end
