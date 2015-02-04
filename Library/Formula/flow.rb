require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.2.0.tar.gz"
  sha1 "041281c08ac15dda22348b2ee3707a02f48a480e"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "b58208c9f9e44614e608ba24a495a0e53d8ebd59" => :yosemite
    sha1 "c1b52c4332cf767deedcaa0a6f192fbb51aadca5" => :mavericks
    sha1 "b677012cca3a65266eb82b47458c5775ce3ab4db" => :mountain_lion
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
