require "formula"

class Screenfetch < Formula
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.6.5.tar.gz"
  sha1 "b409cf4c66fe5cdd8ee9ecfa85d1234a76a63588"
  head "git://git.silverirc.com/screenfetch.git", :shallow => false

  bottle do
    cellar :any
    sha1 "b033eceff0676b03c4cb88c8a9796fc71de25a11" => :mavericks
    sha1 "00865c22570be9c67aca83bf032e206681e9d187" => :mountain_lion
    sha1 "639dcfc9107f678d08d47e4ed1351a55898ff1f6" => :lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
