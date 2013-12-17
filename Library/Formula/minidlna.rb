require 'formula'

class Minidlna < Formula
  homepage 'http://sourceforge.net/projects/minidlna/'
  url      'http://softlayer-dal.dl.sourceforge.net/project/minidlna/minidlna/1.1.0/minidlna-1.1.0.tar.gz'
  sha1     '9d5da7052db77fb4f4dc1b51348a852705d962ac'

  depends_on 'libvorbis'
  depends_on 'libogg'
  depends_on 'flac'
  depends_on 'libid3tag'
  depends_on 'libexif'
  depends_on 'libjpeg'
  depends_on 'ffmpeg'
  depends_on 'libtool'
  depends_on 'gettext'

  def patches
      'https://gist.github.com/econnell/8009695/raw/802e7318fafe3823bd193f1ca041ea161bfd766d/minidlna-macosx.patch'
  end
  

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
