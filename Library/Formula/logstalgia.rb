require 'formula'

class Logstalgia < Formula
  url 'http://logstalgia.googlecode.com/files/logstalgia-1.0.2.tar.gz'
  homepage 'http://code.google.com/p/logstalgia/'
  sha1 '4a3c7cc4684362d23a3ef48db9a4e800366251ed'

  depends_on 'sdl'
  depends_on 'sdl_image'
  depends_on 'ftgl'

  def install
    ENV.x11 # For Freetype

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking"
    system "make install"
  end
end
