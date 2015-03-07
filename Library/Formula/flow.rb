require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.5.0.tar.gz"
  sha1 "cbb960627f2838d890e99e6a2c1277dbabcd04db"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "b9082e71fdc9467c3e30a0e40c13fbdc3e45e188efe98545c1bc6ff7692a14d9" => :yosemite
    sha256 "30615b11e91c9a53a4ef2d540b888ad3426254d573c010e2225b7dad2e7386f1" => :mavericks
    sha256 "653c5f295a06299815f5f1bc781399608f58bb3febdb97510a0786f85b256115" => :mountain_lion
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
