require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.3.0.tar.gz"
  sha1 "d325b01c2b42ecb72e3e11dbb988ed08c5e79702"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "4eafa6426b9f2785a5c5fe44febcde49e2d5ece9" => :yosemite
    sha1 "40aeac15dfafe1b6641ae1abf48f63d2c34354bc" => :mavericks
    sha1 "87f1da882ce1ae7ccd2c8865a46b79a4a7162546" => :mountain_lion
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
