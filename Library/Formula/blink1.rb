require "formula"

class Blink1 < Formula
  homepage "http://thingm.com/products/blink-1.html"
  url "https://github.com/todbot/blink1/archive/v1.81.tar.gz"
  sha1 "8fd96bfad3e6781b165848ef59723fd4ceb16bc4"

  bottle do
    cellar :any
    sha1 "3d647127449b9f57d660fd75f0b9cba64463da0b" => :mavericks
    sha1 "3bfa0403de5aba1f4e2b721bd8561c9b3e50d8c3" => :mountain_lion
    sha1 "44a769f44423129f2885d6212f8ec089aa9519ee" => :lion
  end

  def install
    cd "commandline" do
      system "make"
      bin.install "blink1-tool"
      lib.install "libBlink1.dylib"
      include.install "blink1-lib.h"
    end
  end

  test do
    system "#{bin}/blink1-tool", "--version"
  end
end
