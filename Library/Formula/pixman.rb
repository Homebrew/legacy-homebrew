require 'formula'

class Pixman <Formula
  url 'http://www.cairographics.org/releases/pixman-0.21.2.tar.gz'
  homepage 'http://www.cairographics.org/'
  md5 '9e09fd6e58cbf9717140891e0b7d4a7a'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
