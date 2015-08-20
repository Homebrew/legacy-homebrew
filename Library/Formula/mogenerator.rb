class Mogenerator < Formula
  desc "Generate Objective-C code for Core Data custom classes"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.29.tar.gz"
  sha256 "586bb71d647c64db62180e29ba6c5020b103418103ae2fed9481534e2bfec434"

  head "https://github.com/rentzsch/mogenerator.git"

  bottle do
    cellar :any
    sha256 "38f8ab9f1e845067b3f4a30b2330b537f2596b84e17b9a6f332da1367310fa03" => :yosemite
    sha256 "074479af3d6c596d02d843d3ceebd1af782cd3ff268695033ebc0ae325e74673" => :mavericks
    sha256 "d7ca816e9513ddd029c1edc602e7123d321fed043b49bcaae1a196617725db62" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
