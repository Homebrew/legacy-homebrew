require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.11.0.tar.gz"
  sha1 "714ad08030aab07acf76bf4b6c2603a8b193881d"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "698417f76c3258dafbecac21a937bba06ef328ca8ddfae7bf829b71b8a699f37" => :yosemite
    sha256 "6c5788e30b5b3f4be267c88eb39dea6d13abb127beee62c58b37e94739595bb0" => :mavericks
    sha256 "237e13f65416acef0cf106bd1774cb0d2490491c271d37956c5a91a9afcf2971" => :mountain_lion
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
