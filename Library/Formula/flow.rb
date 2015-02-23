require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.4.0.tar.gz"
  sha1 "16057f713fa2b3efa42d3fdd17de3c93ecd00e15"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "0442f581a9a5947369fa07ed23aeab1a487c1f6c" => :yosemite
    sha1 "7a720d6cb9b7f5515b79cb4a15a1559081e80761" => :mavericks
    sha1 "415ebe4c7bbdb865f5593ee65112c89ded72515e" => :mountain_lion
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
