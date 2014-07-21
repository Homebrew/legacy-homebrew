require 'formula'

class Argtable < Formula
  homepage 'http://argtable.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13/argtable2-13.tar.gz'
  version '2.13'
  sha1 'bce828c64c35e16f4c3f8e1f355e4a2a97fe3289'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
