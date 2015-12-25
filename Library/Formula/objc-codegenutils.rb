class ObjcCodegenutils < Formula
  desc "Three small tools to help work with XCode"
  homepage "https://github.com/square/objc-codegenutils"
  url "https://github.com/square/objc-codegenutils/archive/v1.0.tar.gz"
  sha256 "98b8819e77e18029f1bda56622d42c162e52ef98f3ba4c6c8fcf5d40c256e845"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7b945db595b07ee5677902586e01002ba555affdcae366f1fcbe919a6013772" => :el_capitan
    sha256 "46d389e6ec12462dfbdd97822ce7c6e8156bbe9fac7a3baf04c20cb1991d9f75" => :mavericks
    sha256 "b2a970d293782e5dc6cdf2902df97c89dfa3552aeb5994c7b035a256e5659868" => :mountain_lion
  end

  head "https://github.com/square/objc-codegenutils.git"

  depends_on :macos => :mountain_lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "codegenutils.xcodeproj", "-target", "assetgen", "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-assetgen"
    xcodebuild "-target", "colordump", "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-colordump"
    xcodebuild "-target", "identifierconstants", "-configuration", "Release", "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/objc-identifierconstants"
  end

  test do
    # Would do more verification here but it would require fixture Xcode projects not in the main repo
    system "#{bin}/objc-assetgen", "-h"
    system "#{bin}/objc-colordump", "-h"
    system "#{bin}/objc-identifierconstants", "-h"
  end
end
