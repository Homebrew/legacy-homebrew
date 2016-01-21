class RSwift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues in Swift projects"
  homepage "https://github.com/mac-cain13/R.swift"
  head "https://github.com/mac-cain13/R.swift.git", :tag => "v1.1.0"

  depends_on :xcode => "7.0"

  def install
    system "xcodebuild", "-configuration", "Release", "-scheme", "rswift", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/rswift"
  end
  
  test do
    system "rswift", "-h"
  end
end
