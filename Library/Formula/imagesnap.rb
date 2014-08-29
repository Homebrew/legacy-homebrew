require 'formula'

class Imagesnap < Formula
  homepage 'http://iharder.sourceforge.net/current/macosx/imagesnap/'
  url 'https://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz'
  sha1 '3761bada4fddc92df0c61750d5ead24cf944c469'

  bottle do
    cellar :any
    sha1 "b2b12f5f47aadb7ae9969458baf1dcda943952bf" => :mavericks
    sha1 "74efb274ecb9068c2002eb4fbf7b9d1f8348dc12" => :mountain_lion
    sha1 "e7cc60e951fdc149c1cf3e39dd6af31f74c2269c" => :lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build", "-sdk", "macosx#{MacOS.version}"
    bin.install "build/Release/imagesnap"
  end
end
