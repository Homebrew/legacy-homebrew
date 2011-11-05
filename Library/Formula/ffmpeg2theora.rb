require 'formula'

class Ffmpeg2theora < Formula
  url 'http://v2v.cc/~j/ffmpeg2theora/downloads/ffmpeg2theora-0.28.tar.bz2'
  homepage 'http://v2v.cc/~j/ffmpeg2theora/'
  md5 '31e389bfa0719f489af38b6fb2bd0a1f'

  depends_on 'pkg-config' => :build
  depends_on 'scons' => :build
  depends_on 'ffmpeg'
  depends_on 'libogg'
  depends_on 'libvorbis'
  depends_on 'theora'

  def install
    system "scons", "install", "prefix=#{prefix}", "mandir=PREFIX/share/man"
  end
end
