require 'formula'

class Asciidoc < Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.4/asciidoc-8.6.4.tar.gz'
  md5 '180512ef2b07b52ef351088f54e5803e'
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
