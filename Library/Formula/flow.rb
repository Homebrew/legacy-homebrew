require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.1.0.tar.gz"
  sha1 "780134b1fffd7f1dd8ba397290133d5a49c6e144"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "cc278985ed101cd8e267be5a80585acc79e15825" => :yosemite
    sha1 "ee8fa0635437c54963c836ea105b69ac65b5f251" => :mavericks
    sha1 "60c22342e4c298034939c29d44b41281bb75fa07" => :mountain_lion
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
