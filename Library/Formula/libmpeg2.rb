require 'formula'

class Libmpeg2 < Formula
  homepage 'http://libmpeg2.sourceforge.net/'
  url 'http://libmpeg2.sourceforge.net/files/libmpeg2-0.5.1.tar.gz'
  sha1 '0f9163d8fd52db5f577ebe45636f674252641fd7'

  depends_on 'sdl'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
