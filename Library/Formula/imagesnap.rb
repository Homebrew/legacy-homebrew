class Imagesnap < Formula
  desc "Tool to capture still images from an iSight or other video source"
  homepage "http://iharder.sourceforge.net/current/macosx/imagesnap/"
  url "https://downloads.sourceforge.net/project/iharder/imagesnap/ImageSnap-v0.2.5.tgz"
  sha256 "2516edd6e8fe35c075f0a6517b9fb8ba9af296f8f29b9e349566b9ba6f729615"

  bottle do
    cellar :any
    revision 1
    sha256 "a8326b38e6f61d48ccd738482b353a714ededbe5dd16a2fb31aae0a575ebf2cc" => :yosemite
    sha256 "b2b1d9d52e2c5284ece4d846a4cff19d417132265f53dd5e1a0c02a964076f90" => :mavericks
    sha256 "31fb3b202848e852d647a11c50634971f4c33dd61c0222f787a81fd7546ab973" => :mountain_lion
    sha256 "72aaab7f5666295a48f2050a842ae9e04c6696507df68eed87559ace303c2dae" => :lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "ImageSnap.xcodeproj", "SYMROOT=build", "-sdk", "macosx#{MacOS.version}"
    bin.install "build/Release/imagesnap"
  end
end
