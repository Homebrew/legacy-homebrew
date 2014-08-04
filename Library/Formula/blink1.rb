require "formula"

class Blink1 < Formula
  homepage "http://thingm.com/products/blink-1.html"
  url "https://github.com/todbot/blink1/archive/v1.91.tar.gz"
  sha1 "255a00e457e7559685060b2aa09b96c5589c2b9d"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha1 "3d9ad539d1e56cc22f17cdba283408674f885a4a" => :mavericks
    sha1 "f8bb65ba7c626220a961f715c053825e8e6a808b" => :mountain_lion
    sha1 "4b2d7582e802686b6208fd5b1f00f8bd11d21e99" => :lion
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
