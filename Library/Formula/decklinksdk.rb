class Decklinksdk < Formula
  desc "The Blackmagic Design Decklink Software Development Kit libraries"
  homepage "https://www.blackmagicdesign.com/support/family/capture-and-playback"
  url "http://software.blackmagicdesign.com/SDK/Blackmagic_DeckLink_SDK_10.1.4.zip"
  sha256 "65d4517a454f3809fffea1c2e1ceab11887e1e4530f278078a63cd52bb24ff73"

  def install
    include.install Dir["Mac/include/*"]
  end
end
