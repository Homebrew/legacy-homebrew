require 'formula'

class FonFlashCli < Formula
  homepage 'http://www.gargoyle-router.com/wiki/doku.php?id=fon_flash'
  url 'http://www.gargoyle-router.com/downloads/src/gargoyle_1.5.6-src.tar.gz'
  version '1.5.6'
  sha1 'e6047eb8edb6c95ff174b8639d7291a10deccd97'

  def install
    cd 'fon-flash' do
      system "make fon-flash"
      bin.install 'fon-flash'
      prefix.install_metafiles
    end
  end

  def test
    system "#{bin}/fon-flash"
  end
end
