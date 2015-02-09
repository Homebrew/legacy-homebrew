require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.2.0.tar.gz"
  sha1 "041281c08ac15dda22348b2ee3707a02f48a480e"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "85f19cd0ae02563604f238acca481be9c80e9d07" => :yosemite
    sha1 "4e7d2948772aa186600b9246df60bcc3cfed1b4f" => :mavericks
    sha1 "e9ce9616ff21755b84b0738197e32ca39fb07fc5" => :mountain_lion
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
