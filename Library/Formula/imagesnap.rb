require 'formula'

class Imagesnap < Formula
  url 'http://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.4.tgz'
  homepage 'http://iharder.sourceforge.net/current/macosx/imagesnap/'
  md5 'eddd65d04782cc7538c009cf8a6f7568'

  def install
    system "xcodebuild -project ImageSnap.xcodeproj SYMROOT=build"
    bin.install "build/Release/imagesnap"
  end
end
