require 'formula'

class Asciidoc <Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.5.1/asciidoc-8.5.1.tar.gz'
  md5 '412fb0c86c3dcb4cc159ef63bd274c90'
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
