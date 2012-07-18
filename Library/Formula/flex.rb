require 'formula'

class Flex < Formula
  homepage 'http://flex.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/flex/flex/flex-2.5.35/flex-2.5.35.tar.bz2'
  sha1 'c507095833aaeef2d6502e12638e54bf7ad2f24a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make install"
  end

  def test
    system "flex --version"
  end
end
