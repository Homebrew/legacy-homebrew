class Httpry < Formula
  desc "Packet sniffer for displaying and logging HTTP traffic"
  homepage "https://github.com/jbittel/httpry"
  url "https://github.com/jbittel/httpry/archive/httpry-0.1.8.tar.gz"
  sha256 "b3bcbec3fc6b72342022e940de184729d9cdecb30aa754a2c994073447468cf0"
  head "https://github.com/jbittel/httpry.git"

  bottle do
    cellar :any
    sha256 "da227ba2d41c8723f5a8e117883cab86e30a730ac9638b23c9a537c825838237" => :yosemite
    sha256 "64236c24fbcf79650ed1cd3c8969c8fa387c279d93da4a2de58227f840955632" => :mavericks
    sha256 "01bcaee52ad4b3bc23d6b725996b8236d4d5a54cff7984c9bc7f733b44ea557c" => :mountain_lion
  end

  depends_on "bsdmake" => :build

  def install
    system "bsdmake"
    bin.install "httpry"
    man1.install "httpry.1"
    doc.install Dir["doc/*"]
  end

  test do
    system bin/"httpry", "-h"
  end
end
