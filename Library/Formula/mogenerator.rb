class Mogenerator < Formula
  desc "Generate Objective-C code for Core Data custom classes"
  homepage "https://rentzsch.github.io/mogenerator/"
  url "https://github.com/rentzsch/mogenerator/archive/1.30.tar.gz"
  sha256 "a89fa68c9ede26b505259a009e1c342fd32f29bc0e9bff8657985637c9f05967"

  head "https://github.com/rentzsch/mogenerator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1835c91592254987fc8350e2f03259b3161129eb0015d5a6ddc162bfe8d09af8" => :el_capitan
    sha256 "5b2640442b4f9e5d7d1fd0b7b495e100fa14bb0f42a287af5bec25b8305a3dc1" => :yosemite
  end

  depends_on :xcode => :build
  depends_on :macos => :yosemite

  def install
    xcodebuild "-target", "mogenerator", "-configuration", "Release", "SYMROOT=symroot", "OBJROOT=objroot"
    bin.install "symroot/Release/mogenerator"
  end
end
