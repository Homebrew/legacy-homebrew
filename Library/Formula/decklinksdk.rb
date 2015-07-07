require 'formula'

class Decklinksdk < Formula
  homepage 'http://www.blackmagicdesign.com/support/sdks/'
  url 'http://software.blackmagicdesign.com/SDK/Blackmagic_DeckLink_SDK_10.1.4.zip'
  sha256 '65d4517a454f3809fffea1c2e1ceab11887e1e4530f278078a63cd52bb24ff73'

  def install
      
    # blackmagic's DeckControl bin names conflict with deckcontrol by BAVC
    mv "Mac/Samples/bin/DeckControl", "Mac/Samples/bin/DeckControlsdk"
    
    bin.install 'Mac/Samples/bin/BypassControl'
    bin.install 'Mac/Samples/bin/CaptureFromTape'
    bin.install 'Mac/Samples/bin/DeckControlsdk'
    bin.install 'Mac/Samples/bin/DeviceList'
    bin.install 'Mac/Samples/bin/ExportToTape'
    include.install Dir['Mac/include/*']
  end
end
