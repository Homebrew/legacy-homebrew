require 'formula'

class Asciidoc < Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.5/asciidoc-8.6.5.tar.gz'
  md5 '9247724283501ec1cfb27d5eae9e5eaf'
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
