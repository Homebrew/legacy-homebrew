require 'formula'

class Libmpeg2 <Formula
  url 'http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz'
  homepage 'http://libmpeg2.sourceforge.net/'
  md5 '0f92c7454e58379b4a5a378485bbd8ef'

  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
