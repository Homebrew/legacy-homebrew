require 'formula'

class Exiv2 < Formula
  url 'http://www.exiv2.org/exiv2-0.21.1.tar.gz'
  homepage 'http://www.exiv2.org'
  md5 '5c99bbcaa998f6b200b92f2bf0ac4f9e'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
