require 'formula'

class Pc8x8Font < Formula
  url 'http://www.zone38.net/font/pc8x8.zip'
  sha1 '4dbd149bb97b5b4f3464fcbda2387a479b09acb7'
end

class Psftools < Formula
  url 'http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz'
  homepage 'http://www.seasip.demon.co.uk/Unix/PSF/'
  md5 '159022aae93a797dbc2a01014acbd115'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  def test
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    mktemp do
      Pc8x8Font.new.brew do
        system "#{bin}/fon2fnts pc8x8.fon"
        raise unless File.exist? "PC8X8_9.fnt"
      end
    end
  end
end
