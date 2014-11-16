require 'formula'

class Psftools < Formula
  homepage 'http://www.seasip.demon.co.uk/Unix/PSF/'
  url 'http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz'
  sha1 '4e8b2e7686532a25c18cacaeb90a8f0ed57a30c6'

  depends_on "autoconf" => :build

  resource "pc8x8font" do
    url 'http://www.zone38.net/font/pc8x8.zip'
    sha1 '4dbd149bb97b5b4f3464fcbda2387a479b09acb7'
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert File.exist?("PC8X8_9.fnt")
    end
  end
end
