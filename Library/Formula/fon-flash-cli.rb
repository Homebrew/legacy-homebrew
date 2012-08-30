require 'formula'

class FonFlashCli < Formula
  homepage 'http://www.gargoyle-router.com/wiki/doku.php?id=fon_flash'
  url 'http://www.gargoyle-router.com/downloads/fon-flash/fon-flash-src.tar.gz'
  version '0.0.1'
  sha1 '278a5476275ac7fc0dd343fa3baa7f6dc6ed84ff'

  def install
    system "make fon-flash"
    bin.install 'fon-flash' 
  end

  def test
    system "fon-flash"
  end
end
