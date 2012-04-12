require 'formula'

class Vp < Formula
  homepage 'http://www.elfga.com/~erik/'
  url 'http://www.elfga.com/~erik/files/vp-1.7.tar.gz'
  md5 '5caf42e831b036ca52fa55e944951033'

  depends_on 'sdl_image'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
