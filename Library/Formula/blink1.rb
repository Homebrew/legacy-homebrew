class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "http://thingm.com/products/blink-1.html"
  url "https://github.com/todbot/blink1/archive/v1.96.tar.gz"
  sha1 "474487e72afa22b3dced246571546e8a6f49c939"
  head "https://github.com/todbot/blink1.git"

  bottle do
    cellar :any
    sha1 "68e5d21d7afd4378a3b6ee7a5ef94dc6f917bbcf" => :yosemite
    sha1 "eeeeb080650caefd4c221999b57a67f0dfc10e6f" => :mavericks
    sha1 "4de3e19fe8ff7d3a4736c8a947adcd05dd37abf2" => :mountain_lion
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
    system bin/"blink1-tool", "--version"
  end
end
