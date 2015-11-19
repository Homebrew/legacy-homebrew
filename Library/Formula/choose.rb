class Choose < Formula
  desc "Hybrid string fuzzy matcher that uses both std{in,out} and a native GUI"
  homepage "https://github.com/sdegutis/choose"
  url "https://github.com/sdegutis/choose/archive/1.0.tar.gz"
  sha256 "b1d16c6e143e2a9e9b306cd169ce54535689321d8f016308ff26c82c3d2931bf"

  depends_on :xcode => :build

  def install
    xcodebuild "SDKROOT=", "SYMROOT=build"
    bin.install "build/Release/choose"
  end

  test do
    system "#{bin}/choose", "-h"
  end
end
