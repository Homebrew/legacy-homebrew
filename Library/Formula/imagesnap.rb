require 'formula'

class Imagesnap < Formula
  homepage 'http://iharder.sourceforge.net/current/macosx/imagesnap/'
  url 'https://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz'
  sha1 '3761bada4fddc92df0c61750d5ead24cf944c469'

  depends_on :xcode

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build", "-sdk", "macosx#{MacOS.version}"
    bin.install "build/Release/imagesnap"
  end
end
