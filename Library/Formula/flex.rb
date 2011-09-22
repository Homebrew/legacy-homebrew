require 'formula'

class Flex < Formula
  url 'http://sourceforge.net/projects/flex/files/flex/flex-2.5.35/flex-2.5.35.tar.gz'
  homepage 'http://flex.sourceforge.net'
  md5 '201d3f38758d95436cbc64903386de0b'
  version '2.5.35'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}", "--infodir=#{info}"
    system "make install"
  end

  def test
    system "flex --version"
  end
end
