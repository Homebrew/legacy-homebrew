require 'formula'

class Asciitex < Formula
  url 'http://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz'
  homepage 'http://asciitex.sourceforge.net'
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
