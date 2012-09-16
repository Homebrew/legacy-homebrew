require 'formula'

class Qtplay < Formula
  homepage 'https://sites.google.com/site/rainbowflight2/'
  url 'https://sites.google.com/site/rainbowflight2/qtplay1.3.1.tar.gz'
  sha1 'fd7394675c972377a48c2ff8e0a774853c0be6a3'

  def install
    # Only a 32-bit binary is supported
    system ENV.cc, "qtplay.c", "-arch", "i386", "-framework", "QuickTime", "-framework", "Carbon", "-o", "qtplay"
    bin.install 'qtplay'
    man1.install 'qtplay.1'
    prefix.install 'Readme.rtf'
  end

  def test
    system "#{bin}/qtplay", "--help"
  end
end
