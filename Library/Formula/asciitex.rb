require 'formula'

class Asciitex < Formula
  homepage 'http://asciitex.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz'
  sha1 'b37d300910952c117f82f77dd2da99a7b9a79db7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gtk"
    inreplace 'Makefile', 'man/asciiTeX_gui.1', ''
    system "make install"
    prefix.install 'EXAMPLES'
  end

  def test
    system "#{bin}/asciiTeX", "-f", "#{prefix}/EXAMPLES"
  end
end
