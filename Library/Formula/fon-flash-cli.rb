require 'formula'

class FonFlashCli < Formula
  homepage 'http://www.gargoyle-router.com/wiki/doku.php?id=fon_flash'
  url 'http://www.gargoyle-router.com/downloads/src/gargoyle_1.5.6-src.tar.gz'
  version '1.5.6'
  sha1 'e6047eb8edb6c95ff174b8639d7291a10deccd97'

  def install
    system "cd fon-flash; make fon-flash"
    bin.install 'fon-flash/fon-flash' 
  end

  def test
    system "fon-flash"
  end
end
