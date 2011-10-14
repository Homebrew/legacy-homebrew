require 'formula'

class Py2cairo < Formula
  url 'http://cairographics.org/releases/py2cairo-1.8.10.tar.gz'
  homepage 'http://cairographics.org/pycairo/'
  md5 '87421a6a70304120555ba7ba238f3dc3'

  depends_on 'pkg-config' => :build
  depends_on 'cairo'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end