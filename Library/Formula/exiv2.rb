require 'formula'

class Exiv2 < Formula
  homepage 'http://www.exiv2.org'
  url 'http://www.exiv2.org/exiv2-0.23.tar.gz'
  sha1 '5f342bf642477526f41add11d6ee7787cdcd639f'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
