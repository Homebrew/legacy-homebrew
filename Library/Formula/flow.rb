require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.1.2.tar.gz"
  sha1 "776dd272707c4c640c44aeb127e5485f977c803f"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "1f4f7135e772c874ccf07c628889bfd4efbd2ff9" => :yosemite
    sha1 "c5897b2f28f2e29ff4da42c38af985770610c998" => :mavericks
    sha1 "30a70f252b1e4ed356806edaec243d94c4b61668" => :mountain_lion
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
