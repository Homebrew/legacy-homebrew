require 'brewkit'

class Asciidoc <Formula
  @url='http://www.methods.co.nz/asciidoc/asciidoc-8.4.4.tar.gz'
  @md5='579bcd5762b177ee0ddccece8c34724b'
  @homepage='http://www.methods.co.nz/asciidoc'

  def install
    system "./configure --disable-debug --prefix='#{prefix}'"
    system "make install"
  end
end