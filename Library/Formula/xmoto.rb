require 'formula'

class Xmoto < Formula
  url 'http://download.tuxfamily.org/xmoto/xmoto/0.5.9/xmoto-0.5.9-src.tar.gz'
  homepage 'http://xmoto.tuxfamily.org/'
  sha1 '07757accce78151dc8873bef8270df0e56196772'

  depends_on 'libxml2'
  depends_on 'gettext'
  depends_on 'jpeg'
  depends_on 'sdl'
  depends_on 'sdl_mixer'
  depends_on 'sdl_net'
  depends_on 'sdl_ttf'
  depends_on 'lua'
  depends_on 'ode'

  def install
    # The ENV.x11 picks up libpng and sets CFLAGS and LDFLAGS
    ENV.x11
    # Fixes missing symbols due to png.h v1.5 not including zlib.h
    if MacOS.lion? then
      inreplace 'src/image/tim_png.cpp',
                  '#include <string.h>',
                  "#include <string.h>\n#include <zlib.h>"
    end
    system "./configure", "--prefix=#{prefix}", "--with-internal-xdg=1", "--with-apple-opengl-framework"
    system "make install"
  end
end
