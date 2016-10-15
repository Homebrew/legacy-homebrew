require "formula"

class ObjcCodegenutils < Formula
  homepage "https://github.com/square/objc-codegenutils"
  url "https://github.com/square/objc-codegenutils/archive/v1.0.tar.gz"
  sha1 "ed22e553e3b0f5aaa445d912af287714aeb09f7b"

  depends_on :xcode
  depends_on :macos => :mountain_lion

  def install
    xcodebuild "-project", "codegenutils.xcodeproj", "-target", "assetgen", "-configuration", "Release","SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-assetgen"
    xcodebuild "-target", "colordump", "-configuration", "Release","SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-colordump"
    xcodebuild "-target", "identifierconstants", "-configuration", "Release","SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-identifierconstants"
  end

  test do
    # Would do more verification here but it would require fixture Xcode projects not in the main repo
    system "#{bin}/objc-assetgen", "-h"
    system "#{bin}/objc-colordump", "-h"
    system "#{bin}/objc-identifierconstants", "-h"
  end
end
