require 'formula'

class Pixman <Formula
  url 'http://www.cairographics.org/releases/pixman-0.18.0.tar.gz'
  homepage 'http://www.cairographics.org/'
  md5 'a4fb870fc325be258089f1683642e976'

  depends_on 'pkg-config' => :build
  depends_on 'libpng'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
