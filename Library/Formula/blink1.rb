require "formula"

class Blink1 < Formula
  homepage "http://thingm.com/products/blink-1.html"
  url "https://github.com/todbot/blink1/archive/v1.93.tar.gz"
  sha1 "7fee3042474bf04e58c980487fc6c0500cad29b1"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha1 "bc123f11ef3587b3afdf98f656b31283f6bde119" => :mavericks
    sha1 "612bd29c27860748c99ebeb71bc592ebc35117d4" => :mountain_lion
    sha1 "80d5675499d01370f54346a4d2b6324ecbe0ca8b" => :lion
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
