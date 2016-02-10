class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift.git",
    :tag => "v1.1.1",
    :revision => "3a6db62164d8f50ccdf43e59894fffb672fd5e3f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b5b2447a89b3c7742fd3914bac7c94183c57702812a2a37db1310568d245c23" => :el_capitan
    sha256 "41210a939f034cf865000ac58cd2161951f035df6226123d3b597130a0522b87" => :yosemite
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
