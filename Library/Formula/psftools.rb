require 'formula'

class Psftools < Formula
  homepage 'http://www.seasip.demon.co.uk/Unix/PSF/'
  url 'http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz'
  sha1 '4e8b2e7686532a25c18cacaeb90a8f0ed57a30c6'

  resource "pc8x8font" do
    url 'http://www.zone38.net/font/pc8x8.zip'
    sha1 '4dbd149bb97b5b4f3464fcbda2387a479b09acb7'
  end

  def install
    # This very old configure script does not anticipate that passing -g
    # will result in .dSYM directories being created. -g is only passed
    # when CFLAGS is unset (superenv), so let's set it to the empty string
    cflags = ENV['CFLAGS']
    ENV['CFLAGS'] = ''

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    ENV['CFLAGS'] = cflags

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
