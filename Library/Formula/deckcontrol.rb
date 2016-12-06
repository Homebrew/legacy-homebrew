class Deckcontrol < Formula
  desc "Control an attached videodeck via Blackmagic Design Decklink SDK"
  homepage "https://github.com/bavc/deckcontrol"
  url "https://github.com/bavc/deckcontrol/archive/v0.3.tar.gz"
  sha256 "3fe68d35a29051f81d997d4e28a4775f7b3c7899bdc87d60877c554fd1d4c816"
  head "https://github.com/bavc/deckcontrol.git"

  depends_on "decklinksdk" => :build

  def install
    system "make"
    bin.install "deckcontrol"
  end
end
