require 'formula'

class Pixman <Formula
  url 'http://www.cairographics.org/releases/pixman-0.16.4.tar.gz'
  homepage 'http://www.cairographics.org/'
  md5 '7f430cf0de0bf05935d4e21906cb1e6b'

  depends_on 'pkg-config'
  depends_on 'libpng'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    
    system "make install"
  end
end
