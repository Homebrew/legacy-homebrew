require 'formula'

class Gtkwave < Formula
  homepage 'http://gtkwave.sourceforge.net/'
  url 'http://gtkwave.sourceforge.net/gtkwave-3.3.36.tar.gz'
  sha1 'b6e7c17c97f33f332a326494659e947198189b7c'

  depends_on 'gtk+'
  depends_on 'xz'

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system 'make install'
  end
end
