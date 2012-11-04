require 'formula'

class Imagesnap < Formula
  url 'http://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz'
  homepage 'http://iharder.sourceforge.net/current/macosx/imagesnap/'
  sha1 '3761bada4fddc92df0c61750d5ead24cf944c469'

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild -project ImageSnap.xcodeproj SYMROOT=build -sdk macosx#{MacOS.version}"
    bin.install "build/Release/imagesnap"
  end
end
