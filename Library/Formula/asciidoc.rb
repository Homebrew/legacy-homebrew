require 'brewkit'

class Asciidoc <Formula
  @url='http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.4.5/asciidoc-8.4.5.tar.gz'
  @md5='9f21d6e352b3ab668f9def3eb7497da2'
  @homepage='http://www.methods.co.nz/asciidoc'

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end