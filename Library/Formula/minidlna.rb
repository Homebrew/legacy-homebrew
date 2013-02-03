require 'formula'

class Minidlna < Formula
  homepage 'http://sourceforge.net/projects/minidlna/'
  head     'cvs://:pserver:anonymous:@minidlna.cvs.sourceforge.net:/cvsroot/minidlna:minidlna'

  depends_on :automake
  depends_on 'libvorbis'
  depends_on 'libogg'
  depends_on 'libid3tag'
  depends_on 'libexif'
  depends_on 'libjpeg'
  depends_on 'ffmpeg'
  depends_on 'libtool'
  depends_on 'gettext'

  def patches
      'https://gist.github.com/raw/4703012/a7e5c9d88e37cddf3adaa7fe65933e4aa5ab51ee/minidlna-inline-function.patch'
  end
  

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
