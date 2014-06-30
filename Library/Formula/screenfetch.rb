require "formula"

class Screenfetch < Formula
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.5.0.tar.gz"
  sha1 "01d108da5de053b518c1cc49d6e6cc6b9837a59a"
  head 'git://git.silverirc.com/screenfetch.git', :shallow => false

  bottle do
    cellar :any
    sha1 "ed82df6d755f72c71afe1d1516458f91b173b182" => :mavericks
    sha1 "05547e6c3c2744f413da596117c1a0113eb818e4" => :mountain_lion
    sha1 "1508538c438e2140652aafe6534fc9075ef1f62d" => :lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
