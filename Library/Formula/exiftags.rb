require 'formula'

class Exiftags < Formula
  url 'http://johnst.org/sw/exiftags/exiftags-1.01.tar.gz'
  homepage 'http://johnst.org/sw/exiftags'
  md5 '9d5bce968fdde2dc24ba49c0024dc0cc'

  def install
    system 'make'
    bin.install  %w[exiftags exifcom exiftime]
    man1.install %w[exiftags.1 exifcom.1 exiftime.1]
  end
end
