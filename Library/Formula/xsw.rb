require 'formula'

class Xsw <Formula
  url 'http://xsw.googlecode.com/files/xsw-0.3.5.tar.gz'
  homepage 'http://code.google.com/p/xsw/'
  sha1 'fe4cffcc8bcd3149f4ecbf2011ad78a8ab7f1dd4'

  depends_on 'sdl'
  depends_on 'sdl_ttf'
  depends_on 'sdl_image'
  depends_on 'sdl_gfx'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
