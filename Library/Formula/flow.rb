require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.1.5.tar.gz"
  sha1 "67f03332a785f4b897f67c67ccd366b0ebc0df26"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "1e7a1bddf6a5e25d5b9659eecf9c59aafad19067" => :yosemite
    sha1 "0b48153daada81af835d08759091fea6ddfe5f99" => :mavericks
    sha1 "8bf895eec56205c38b599f936d9c639527faaa11" => :mountain_lion
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
