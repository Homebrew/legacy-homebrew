require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.9.2.tar.gz"
  sha1 "33147962ebbcc60535af17e18a01cc5c38d81a11"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "ada4689cf2b5276e9da9f57bbffb4c87651e5752e37dfb98d24032d620e53d46" => :yosemite
    sha256 "4db477d04f37b4721fb480c63d179d410180c21007065e613abcf9c015b4a2a1" => :mavericks
    sha256 "2ceabc8ce8d38b675abb18bf8147a54d893f9faa6c29bdc4dae8f0cc657c81d5" => :mountain_lion
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
