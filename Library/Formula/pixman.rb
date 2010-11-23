require 'formula'

class Pixman <Formula
  url 'http://www.cairographics.org/releases/pixman-0.21.2.tar.gz'
  homepage 'http://www.cairographics.org/'
  sha1 'c0ff07d7e4877dd4d0d369ca09e50ca956e3386e'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
