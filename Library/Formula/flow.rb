require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.1.5.tar.gz"
  sha1 "67f03332a785f4b897f67c67ccd366b0ebc0df26"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "92f318f35f60894669c92ac0cb0d09f899170a0a" => :yosemite
    sha1 "b6d6765dc84d1023a02cd9da3bc6a8d56eb5b996" => :mavericks
    sha1 "53f623a67b70f867a76ce6c809b00548e0a0819d" => :mountain_lion
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
