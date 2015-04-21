require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.9.2.tar.gz"
  sha1 "33147962ebbcc60535af17e18a01cc5c38d81a11"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "792de6ff4fd77d93fafd4223218e5d34ef3f6384b703db44bfba14dfdf938a2d" => :yosemite
    sha256 "14d1c1262fab9928b942cd464b3997175d5d6fb1c74c5999cadca9fe89f05ede" => :mavericks
    sha256 "44267cdec47e7b17486687276bb6c0fbb77925c3d5801d5729b21338c823cc46" => :mountain_lion
  end

  depends_on "objective-caml" => :build

  def install
    system "make"
    bin.install "bin/flow"
    (share/"flow").install "bin/examples"
  end

  test do
    output = `#{bin}/flow single #{share}/flow/examples/01_HelloWorld`
    assert_match(/This type is incompatible with/, output)
    assert_match(/Found 1 error/, output)
  end
end
