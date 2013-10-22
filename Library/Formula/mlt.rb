require 'formula'

class Mlt < Formula
  homepage 'http://www.mltframework.org/'
  url 'http://downloads.sourceforge.net/mlt/mlt/mlt-0.9.0.tar.gz'
  sha1 '76bf18f4442801fae963c5a676d6626e383d1617'

  depends_on 'pkg-config' => :build

  depends_on 'atk'
  depends_on 'ffmpeg'
  depends_on 'frei0r'
  depends_on 'libdv'
  depends_on 'libsamplerate'
  depends_on 'libvorbis'
  depends_on 'sdl'
  depends_on 'sox'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-gtk2",
                          "--disable-jackrack",
                          "--disable-swfdec"

    system "make"
    system "make", "install"
  end
end
