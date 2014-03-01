require 'formula'

class FonFlashCli < Formula
  homepage 'http://www.gargoyle-router.com/wiki/doku.php?id=fon_flash'
  url 'http://www.gargoyle-router.com/downloads/src/gargoyle_1.5.11-src.tar.gz'
  version '1.5.11'
  sha1 'a5184b7754b9db3ea0c19602e4a8ddbcc1bde7fe'

  def install
    cd 'fon-flash' do
      system "make fon-flash"
      bin.install 'fon-flash'
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/fon-flash"
  end
end
