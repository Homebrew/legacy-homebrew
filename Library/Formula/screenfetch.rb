require "formula"

class Screenfetch < Formula
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.5.0.tar.gz"
  sha1 "01d108da5de053b518c1cc49d6e6cc6b9837a59a"
  head 'git://git.silverirc.com/screenfetch.git', :shallow => false

  bottle do
    cellar :any
    sha1 "a0af0c7172066ca31cf6eb542a4e7b642dd79dc7" => :mavericks
    sha1 "5ee15d688ee29db874a8171869bf0d8c970d8458" => :mountain_lion
    sha1 "ae7d892faa753aca39548ad14a5f949216c76051" => :lion
  end

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
