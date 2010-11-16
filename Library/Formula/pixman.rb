require 'formula'

class Pixman <Formula
  url 'http://www.cairographics.org/releases/pixman-0.20.0.tar.gz'
  homepage 'http://www.cairographics.org/'
  sha1 '51f264f4e8c4594d68669fb0af81312a1f0d0598'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
