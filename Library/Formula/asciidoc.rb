require 'formula'

class Asciidoc <Formula
  url 'http://downloads.sourceforge.net/project/asciidoc/asciidoc/8.6.3/asciidoc-8.6.3.tar.gz'
  md5 '1ef39786ee1b4c8a788584e73db2c55a'
  homepage 'http://www.methods.co.nz/asciidoc'

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make install"
  end
end
