class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
    :tag => "v1.3.0",
    :revision => "c7b9104364315f9dfa0997feff5bc471c45aa5ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb2d081b82b614c352f8c15d64eec415110e233532e50467faae7e2e4f6851d2" => :el_capitan
    sha256 "25dd772c3872f84f4939fc545eeac76ffa84f3d3b081cdc24ba4da570cc84bd7" => :yosemite
  end

  depends_on :xcode => "7.0"

  def install
    xcodebuild "-configuration", "Release", "-scheme", "rswift", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/rswift"
  end

  test do
    system "#{bin}/rswift", "-h"
  end
end
