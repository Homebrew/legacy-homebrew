require 'formula'

class Gtkwave < Formula
  homepage 'http://gtkwave.sourceforge.net/'
  url 'http://gtkwave.sourceforge.net/gtkwave-3.3.41.tar.gz'
  sha1 'e1be0dda6b4f89399269c43ee277d62af84e6d84'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'xz'
  depends_on :x11

  def install
    system './configure', "--prefix=#{prefix}", '--disable-dependency-tracking'
    system 'make install'
  end
end
