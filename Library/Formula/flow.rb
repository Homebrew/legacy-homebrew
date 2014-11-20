require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.1.1.tar.gz"
  sha1 "6786fa11bdca29b1bdb0602616c6b0c165a00b9e"
  head "https://github.com/facebook/flow.git"

  bottle do
    cellar :any
    sha1 "d5bcb891128f8efa2290082859016183cc16aaf1" => :yosemite
    sha1 "fb6245516745eb00bd0b32b5e5330aa298f18cb2" => :mavericks
    sha1 "9507787f95b91c48528a8717436d9e2f865383b8" => :mountain_lion
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
