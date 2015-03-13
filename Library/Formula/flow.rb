require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.6.0.tar.gz"
  sha1 "8185edc3598f4261b25cc4300f3f7cee12312240"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "b18ff22833c0bb393e67bcbf815b0bdf5ed75f2390898f8e6ace342a5d8f79f9" => :yosemite
    sha256 "d438368253344540c8af406725cf8514f579ec9e7ea41fb1faa700214b131d44" => :mavericks
    sha256 "72f6f76de95e9629a7907f2531adad486419c5c452189ca7cc4baae545d82174" => :mountain_lion
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
