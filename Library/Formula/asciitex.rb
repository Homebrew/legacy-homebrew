require 'formula'

class Asciitex < Formula
  url 'http://downloads.sourceforge.net/project/asciitex/asciiTeX-0.21.tar.gz'
  homepage 'http://asciitex.sourceforge.net'
  md5 'b894d924880a5659d9637f30ed5a3bb0'

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
