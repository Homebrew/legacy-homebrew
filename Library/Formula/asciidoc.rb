require 'formula'

class Asciidoc <Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.1/asciidoc-8.6.1.tar.gz'
  md5 '3d16b16a953c0c2d00b6a6d089882d0e'
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
