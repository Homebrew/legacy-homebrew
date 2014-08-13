require "formula"

class Screenfetch < Formula
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.6.0.tar.gz"
  sha1 "283f811cabe17e7ab78cd3bd1233cfc52d5bd7b5"
  head 'git://git.silverirc.com/screenfetch.git', :shallow => false

  bottle do
    cellar :any
    sha1 "7d914abc94e2c9832976e251b6ddef04f61bdebf" => :mavericks
    sha1 "5eeedcb79a31a0d11fa8fc076896889dfbdfdb0d" => :mountain_lion
    sha1 "942fc704bef0d7e64ff9d90654d2ab6fdf5a28fd" => :lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
