require 'formula'

class Exiftags < Formula
  homepage 'http://johnst.org/sw/exiftags'
  url 'http://johnst.org/sw/exiftags/exiftags-1.01.tar.gz'
  sha1 '06636feb7d5c5835da01d5da8cd0f4a291d23fd8'

  def install
    system 'make'
    bin.install  %w[exiftags exifcom exiftime]
    man1.install %w[exiftags.1 exifcom.1 exiftime.1]
  end
end
