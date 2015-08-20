class Mogenerator < Formula
  desc "Generate Objective-C code for Core Data custom classes"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.29.tar.gz"
  sha256 "586bb71d647c64db62180e29ba6c5020b103418103ae2fed9481534e2bfec434"

  head "https://github.com/rentzsch/mogenerator.git"

  bottle do
    cellar :any
    sha1 "6a0c63e99ecae49d70b569b5b4507b8352ada961" => :mavericks
    sha1 "abc1bcf2e7d1ebbb3258023f57e082052061a19c" => :mountain_lion
    sha1 "fc60b8470f7e5441a599496aa637fd21da83934a" => :lion
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
