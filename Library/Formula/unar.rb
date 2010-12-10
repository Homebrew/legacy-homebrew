require 'formula'

class Unar <Formula
  url 'http://theunarchiver.googlecode.com/files/unar0.3.zip'
  homepage 'http://code.google.com/p/theunarchiver/'
  sha1 'b5254c233badaee017ed71d1a657d8b3daa07826'

  def install
      bin.install 'unar'
      bin.install 'lsar'
  end
end
