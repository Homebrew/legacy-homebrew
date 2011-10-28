require 'formula'

class Alac < Formula
  head 'https://svn.macosforge.org/repository/alac/trunk/', :using => StrictSubversionDownloadStrategy
  homepage 'http://alac.macosforge.org/'

  def install
    Dir.chdir 'codec' do
      system 'make'
      lib.install 'libalac.a'
    end
    Dir.chdir 'convert-utility' do
      system 'make'
      bin.install 'alacconvert'
    end
    (include+'alac').install Dir['codec/*.h']
  end

  def test
    system "test -e #{bin}/alacconvert"
  end
end
