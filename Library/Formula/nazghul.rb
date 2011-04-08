require 'formula'

class Nazghul < Formula
  url 'http://downloads.sourceforge.net/project/nazghul/nazghul/nazghul-0.7.0/nazghul-0.7.0.tar.gz'
  homepage 'http://myweb.cableone.net/gmcnutt/nazghul.html'
  md5 '3a3b08ee180163030bc9934d6fb40de8'

  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'sdl_mixer'

  def install
    ENV.x11 # For libpng
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    # Not sure why the ifdef is commented out in this file
    inreplace "src/skill.c", "#include <malloc.h>", ""
    system "make install"
  end

  def caveats; <<-EOS.undent
    The built-in game for this engine is called Haxima. To run:
        haxima.sh
    EOS
  end
end
