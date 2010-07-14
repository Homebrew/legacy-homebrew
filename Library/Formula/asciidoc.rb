require 'formula'

class Asciidoc <Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.5.3/asciidoc-8.5.3.tar.gz'
  md5 '7377872275c2a575151655b19ac6dd3e'
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
