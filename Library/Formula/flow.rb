require "formula"

class Flow < Formula
  homepage "http://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.1.0.tar.gz"
  sha1 "780134b1fffd7f1dd8ba397290133d5a49c6e144"

  depends_on "objective-caml"

  def install
    system "make"
    bin.install "bin/flow"
  end

  test do
    system "#{bin}/flow", "--help"
  end
end
