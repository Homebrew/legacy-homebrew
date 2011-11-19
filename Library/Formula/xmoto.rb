require 'formula'

class Xmoto < Formula
  url 'http://download.tuxfamily.org/xmoto/xmoto/0.5.7/xmoto-0.5.7-src.tar.gz'
  homepage 'http://xmoto.tuxfamily.org/'
  md5 'c4b8477412445e114843b3b6163937f3'

  depends_on 'gettext'
  depends_on 'jpeg'
  depends_on 'sdl'
  depends_on 'sdl_mixer'
  depends_on 'sdl_net'
  depends_on 'sdl_ttf'
  depends_on 'lua'
  depends_on 'ode'

  def install
    ENV.append "CPPFLAGS", "-I#{include} -I/usr/X11/include"
    ENV.append "LDFLAGS", "-framework OpenGL -framework Cocoa -L#{lib} -L/usr/X11/lib -lstdc++ -lSDLmain -lSDL -lSDL_mixer -lpng"
    system "./configure", "--prefix=#{prefix}", "--with-internal-xdg=1"
    system "make install"
  end
end
