require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.8.0.tar.gz"
  sha1 "eb3ee22845441a323fe80b8e0e7d7b78ee653904"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha256 "b1f598969a4a76cd5166e8834a730d92b51fe3dce54de7c906cfe70705a87544" => :yosemite
    sha256 "6f3467020fe682dfa52b8f4b3d49e001e8fdca60b10ab70c05cd6fed7e73fb0f" => :mavericks
    sha256 "c3809cc61d4f5601408d282746a7445cdcbeaafc60e4332e900e3228e39fd211" => :mountain_lion
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
