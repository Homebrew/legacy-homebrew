require 'formula'

class Pc8x8Font < Formula
  url 'http://www.zone38.net/font/pc8x8.zip'
  sha1 '4dbd149bb97b5b4f3464fcbda2387a479b09acb7'
end

class Psftools < Formula
  homepage 'http://www.seasip.demon.co.uk/Unix/PSF/'
  url 'http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz'
  sha1 '4e8b2e7686532a25c18cacaeb90a8f0ed57a30c6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    Pc8x8Font.new.brew do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      raise unless File.exist? "PC8X8_9.fnt"
    end
  end
end
