require 'formula'
require 'hardware'

class Dosbox <Formula
  url 'http://downloads.sourceforge.net/project/dosbox/dosbox/0.74/dosbox-0.74.tar.gz'
  homepage 'http://www.dosbox.com/'
  md5 'b9b240fa87104421962d14eee71351e8'

  depends_on 'sdl'
  depends_on 'sdl_net'
  depends_on 'sdl_sound'

  def install
    ENV.libpng
    ENV.fast

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-sdltest",
                          "--enable-core-inline"
    system "make"

    bin.install 'src/dosbox'
    man1.install gzip('docs/dosbox.1')
  end
end
